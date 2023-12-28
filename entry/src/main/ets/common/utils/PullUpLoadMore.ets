import promptAction from '@ohos.promptAction';
import { CommonConstant as Const } from '../constant/CommonConstant';
import NewsViewModel, { NewsData } from '../../viewmodel/NewsViewModel';
import NewsModel from '../../viewmodel/NewsModel';

export function touchMoveLoadMore(newsModel: NewsModel, event: TouchEvent) {
    if (newsModel.endIndex === newsModel.newsData.length - 1 || newsModel.endIndex === newsModel.newsData.length) {
        newsModel.offsetY = event.touches[0].y - newsModel.downY;
        if (Math.abs(newsModel.offsetY) > vp2px(newsModel.pullUpLoadHeight) / 2) {
            newsModel.isCanLoadMore = true;
            newsModel.isVisiblePullUpLoad = true;
            newsModel.offsetY = -vp2px(newsModel.pullUpLoadHeight) + newsModel.offsetY * Const.Y_OFF_SET_COEFFICIENT;
        }
    }
}

export function touchUpLoadMore(newsModel: NewsModel) {
    let self: NewsModel = newsModel;
    animateTo({
        duration: Const.ANIMATION_DURATION,
    }, () => {
        self.offsetY = 0;
    })
    if ((self.isCanLoadMore === true) && (self.hasMore === true)) {
        self.isLoading = true;
        setTimeout(() => {
            closeLoadMore(newsModel);
            NewsViewModel.getNewsList(self.currentPage, self.pageSize, Const.GET_NEWS_LIST).then((data: NewsData[]) => {
                if (data.length === self.pageSize) {
                    self.currentPage++;
                    self.hasMore = true;
                } else {
                    self.hasMore = false;
                }
                self.newsData = self.newsData.concat(data);
            }).catch((err: string | Resource) => {
                promptAction.showToast({ message: err });
            })
        }, Const.DELAY_TIME);
    } else {
        closeLoadMore(self);
    }
}

export function closeLoadMore(newsModel: NewsModel) {
    newsModel.isCanLoadMore = false;
    newsModel.isLoading = false;
    newsModel.isVisiblePullUpLoad = false;
}