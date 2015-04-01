#import "HBWLAgentPickerTableCell.h"
#import "../HBWLAgent.h"
#import "../HBWLAgentView.h"
#import <Preferences/PSSpecifier.h>
#include <dlfcn.h>

@implementation HBWLAgentPickerTableCell {
	UIScrollView *_scrollView;
	UIPageControl *_pageControl;

	NSArray *_items;
	NSArray *_agentViews;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

	if (self) {
		_scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
		_scrollView.delegate = self;
		_scrollView.pagingEnabled = YES;
		_scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
		_scrollView.showsHorizontalScrollIndicator = NO;
		[self.contentView addSubview:_scrollView];

		_pageControl = [[UIPageControl alloc] init];
		_pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
		[_pageControl sizeToFit];
		_pageControl.frame = CGRectMake(0, self.contentView.frame.size.height - 15.f - _pageControl.frame.size.height, _pageControl.frame.size.width, _pageControl.frame.size.height);
		_pageControl.userInteractionEnabled = NO; // sorry
		[self.contentView addSubview:_pageControl];

		NSError *error = nil;
		NSArray *bundles = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:[NSURL URLWithString:kHBWLAgentsLocation] includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsSubdirectoryDescendants error:&error];

		if (error) {
			NSLog(@"error, what? %@", error);
			return self;
		}

		NSMutableArray *items = [NSMutableArray array];
		NSMutableArray *agentViews = [NSMutableArray array];

		for (NSURL *url in bundles) {
			if ([url.pathExtension isEqualToString:@"bundle"]) {
				HBWLAgent *agent = [[%c(HBWLAgent) alloc] initWithBundle:[NSBundle bundleWithURL:url]];

				if (!agent) {
					NSLog(@"agent %@ returned nil", url);
					continue;
				}

				[items addObject:agent];

				UIView *containerView = [[[UIView alloc] init] autorelease];
				[_scrollView addSubview:containerView];

				HBWLAgentView *agentView = [[[%c(HBWLAgentView) alloc] init] autorelease];
				agentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
				agentView.center = CGPointMake(containerView.frame.size.width / 2, containerView.frame.size.height / 2);
				[agentView setAgent:agent animated:NO];
				[containerView addSubview:agentView];

				[agentViews addObject:agentView];

				UILabel *nameLabel = [[[UILabel alloc] init] autorelease];
				nameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				nameLabel.font = [UIFont boldSystemFontOfSize:16.f];
				nameLabel.text = agent.name;
				nameLabel.textAlignment = NSTextAlignmentCenter;
				nameLabel.frame = CGRectMake(15.f, 15.f, containerView.frame.size.width - 30.f, ceilf([nameLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)].height));
				[containerView addSubview:nameLabel];
			}
		}

		_items = [items copy];

		_pageControl.numberOfPages = _items.count;

		[self updateSelection];
	}

	return self;
}

- (void)_setAgent:(NSString *)agent {
	if (self.cellTarget) {
		[self.cellTarget performSelector:self.cellAction withObject:agent withObject:self.specifier];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];

	[_pageControl sizeToFit];

	CGFloat left = 0;

	for (UIView *view in _scrollView.subviews) {
		view.frame = CGRectMake(left, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
		left += view.frame.size.width;
	}

	_scrollView.contentSize = CGSizeMake(left, _scrollView.frame.size.height);
}

- (void)updateSelection {
	NSUInteger item = round(_scrollView.contentOffset.x / _scrollView.frame.size.width);

	if (item > _items.count - 1) {
		item = _items.count - 1;
	}

	_pageControl.currentPage = item;

	[self _setAgent:((HBWLAgent *)_items[item]).name];

	[(HBWLAgentView *)_agentViews[item] playAnimation:@"Congratulate"];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	[self updateSelection];
}

@end

#pragma mark - Constructor

%ctor {
	dlopen("/Library/MobileSubstrate/DynamicLibraries/WritingALetter.dylib", RTLD_NOW);
	%init;
}
