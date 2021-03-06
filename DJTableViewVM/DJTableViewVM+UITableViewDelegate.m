//
//  DJComponentTableViewVM+UITableViewDelegate.m
//  DJComponentTableViewVM
//
//  Created by Dokay on 16/1/18.
//  Copyright © 2016年 dj226 All rights reserved.
//

#import "DJTableViewVM+UITableViewDelegate.h"
#import "DJTableViewVMCell.h"
#import "DJTableViewVMSection.h"
#import "DJTableViewVMRow.h"

@implementation DJTableViewVM(UITableViewDelegate)

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if (row.cellHeight == 0 || row.dj_caculateHeightForceRefresh) {
        if (row.heightCaculateType == DJCellHeightCaculateDefault) {
            Class cellClass = [self.registeredClasses objectForKey:row.class];
            row.cellHeight = [cellClass heightWithRow:row tableViewVM:self];
        }else{
            row.cellHeight = [self heightWithAutoLayoutCellWithIndexPath:indexPath];
        }
    }
    return row.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)]){
        return [self.delegate tableView:tableView heightForHeaderInSection:sectionIndex];
    }
    
    if (self.sections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:sectionIndex];
    
    if (section.headerView) {
        return section.headerView.frame.size.height;
    } else if (section.headerTitle.length) {
        if (!UITableViewStyleGrouped) {
            return 22;
        }else{
            CGFloat headerHeight = 0;
            CGFloat headerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 30.0f; // 30 = 15pt horizontal padding on each side
            
            CGSize headerRect = CGSizeMake(headerWidth,DBL_MAX);
            
            CGRect headerFrame = [section.headerTitle boundingRectWithSize:headerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline] }
                                                                   context:nil];
            
            headerHeight = headerFrame.size.height;
            
            return headerHeight + 20.0f;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:heightForFooterInSection:)]){
        return [self.delegate tableView:tableView heightForFooterInSection:sectionIndex];
    }
    
    if (self.sections.count <= sectionIndex) {
        return UITableViewAutomaticDimension;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:sectionIndex];
    
    if (section.footerView) {
        return section.footerView.frame.size.height;
    } else if (section.footerTitle.length) {
        if (!UITableViewStyleGrouped) {
            return 22;
        } else {
            CGFloat footerHeight = 0;
            CGFloat footerWidth = CGRectGetWidth(CGRectIntegral(tableView.bounds)) - 30.0f; // 30 = 15pt horizontal padding on each side
            
            CGSize footerRect = CGSizeMake(footerWidth, DBL_MAX);
            
            CGRect footerFrame = [section.footerTitle boundingRectWithSize:footerRect
                                                                   options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                                attributes:@{ NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote] }
                                                                   context:nil];
            
            footerHeight = footerFrame.size.height;
            
            return footerHeight + 10.0f;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:estimatedHeightForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
    }
    
    if (self.sections.count <= indexPath.section) {
        return UITableViewAutomaticDimension;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    Class cellClass = [self.registeredClasses objectForKey:row.class];
    CGFloat height = [cellClass heightWithRow:row tableViewVM:self];
    
    return height ? height : UITableViewAutomaticDimension;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)]){
        return [self.delegate tableView:tableView viewForHeaderInSection:sectionIndex];
    }
    
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:sectionIndex];
    return section.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIndex
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)]){
        return [self.delegate tableView:tableView viewForFooterInSection:sectionIndex];
    }
    
    if (self.sections.count <= sectionIndex) {
        return nil;
    }
    DJTableViewVMSection *section = [self.sections objectAtIndex:sectionIndex];
    return section.footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    DJTableViewVMSection *section = [self.sections objectAtIndex:indexPath.section];
    DJTableViewVMRow *row = [section.rows objectAtIndex:indexPath.row];
    if ([row respondsToSelector:@selector(setSelectionHandler:)]){
        DJTableViewVMRow *actionRow = (DJTableViewVMRow *)row;
        if (actionRow.selectionHandler) {
            actionRow.selectionHandler(actionRow);
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]){
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayHeaderView:forSection:)]){
        [self.delegate tableView:tableView willDisplayHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDisplayFooterView:forSection:)]){
        [self.delegate tableView:tableView willDisplayFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(cellDidDisappear)]){
        [(UITableViewCell<DJTableViewVMCellDelegate> *)cell cellDidDisappear];
    }
    
    
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]){
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingHeaderView:forSection:)]){
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]){
        [self.delegate tableView:tableView didEndDisplayingFooterView:view forSection:section];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:accessoryButtonTappedForRowWithIndexPath:)]){
        [self.delegate tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]){
        return [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didHighlightRowAtIndexPath:)]){
        [self.delegate tableView:tableView didHighlightRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didUnhighlightRowAtIndexPath:)]){
        [self.delegate tableView:tableView didUnhighlightRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willSelectRowAtIndexPath:)]){
        return [self.delegate tableView:tableView willSelectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willDeselectRowAtIndexPath:)]){
        return [self.delegate tableView:tableView willDeselectRowAtIndexPath:indexPath];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:editingStyleForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView editingStyleForRowAtIndexPath:indexPath];
    }
    
    return UITableViewCellEditingStyleNone;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:titleForDeleteConfirmationButtonForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView titleForDeleteConfirmationButtonForRowAtIndexPath:indexPath];
    }
    
    return NSLocalizedString(@"删除", @"Delete");
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldIndentWhileEditingRowAtIndexPath:)]){
        return [self.delegate tableView:tableView shouldIndentWhileEditingRowAtIndexPath:indexPath];
    }
    
    return YES;
}

- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:willBeginEditingRowAtIndexPath:)]){
        [self.delegate tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]){
        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:targetIndexPathForMoveFromRowAtIndexPath:toProposedIndexPath:)]){
        return [self.delegate tableView:tableView targetIndexPathForMoveFromRowAtIndexPath:sourceIndexPath toProposedIndexPath:proposedDestinationIndexPath];
    }
    
    DJTableViewVMSection *sourceSection = [self.sections objectAtIndex:sourceIndexPath.section];
    DJTableViewVMRow *rowVM = [sourceSection.rows objectAtIndex:sourceIndexPath.row];
    if (rowVM.moveHandler) {
        BOOL allowed = rowVM.moveHandler(rowVM, sourceIndexPath, proposedDestinationIndexPath);
        if (!allowed){
            return sourceIndexPath;
        }
    }
    
    return proposedDestinationIndexPath;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:shouldShowMenuForRowAtIndexPath:)]){
        return [self.delegate tableView:tableView shouldShowMenuForRowAtIndexPath:indexPath];
    }
    
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:canPerformAction:forRowAtIndexPath:withSender:)]){
        return [self.delegate tableView:tableView canPerformAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(UITableViewDelegate)] && [self.delegate respondsToSelector:@selector(tableView:performAction:forRowAtIndexPath:withSender:)]){
        [self.delegate tableView:tableView performAction:action forRowAtIndexPath:indexPath withSender:sender];
    }
}


@end
