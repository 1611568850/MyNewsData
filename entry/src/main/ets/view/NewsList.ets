import { CommonConstant, PageState } from '../common/constant/CommonConstant'
import { listTouchEvent } from '../common/utils/PullDownRefresh'
import NewsModel from '../viewmodel/NewsModel'
import NewsViewModel, { NewsData, CustomRefreshLoadLayoutClass } from '../viewmodel/NewsViewModel'
import CustomRefreshLoadLayout from './CustomRefreshLoadLayout'
import LoadMoreLayout from './LoadMoreLayout'
import NewsItem from './NewsItem'
import NoMoreLayout from './NoMoreLayout'
import RefreshLayout from './RefreshLayout'

@Component
export default struct NewsList {
    @State newsModel: NewsModel = new NewsModel()
    @Link @Watch('changeCategory') currentIndex: number

    changeCategory() {
        this.newsModel.currentPage = 1
        NewsViewModel.getNewsList(this.newsModel.currentPage, this.newsModel.pageSize, CommonConstant.GET_NEWS_LIST)
            .then((data: NewsData[]) => {
                this.newsModel.pageState = PageState.Success
                if (data.length === this.newsModel.pageSize) {
                    this.newsModel.pageSize++
                    this.newsModel.hasMore = true
                } else {
                    this.newsModel.hasMore = false
                }
                this.newsModel.newsData = data
            }).catch((err: string | Resource) => {
            this.newsModel.pageState = PageState.Fail
        })
    }

    aboutToAppear() {
        this.changeCategory()
    }

    build() {
        Column() {
            if (this.newsModel.pageState === PageState.Success) {
                this.listLayout()
            } else if (this.newsModel.pageState === PageState.Loading) {
                this.LoadingLayout()
            } else {
                this.FailLayout()
            }
        }
        .justifyContent(FlexAlign.Center)
        .width(CommonConstant.FULL_WIDTH)
        .height(CommonConstant.FULL_HEIGHT)
        .onTouch((event: TouchEvent | undefined) => {
            if (event) {
                if (this.newsModel.pageState === PageState.Success) {
                    listTouchEvent(this.newsModel, event)
                }
            }
        })
    }

    @Builder listLayout() {
        List() {
            ListItem() {
                RefreshLayout({
                    refreshLayoutClass: new CustomRefreshLoadLayoutClass(
                        this.newsModel.isVisiblePullDown,
                        this.newsModel.pullDownRefreshImage,
                        this.newsModel.pullDownRefreshText,
                        this.newsModel.pullDownRefreshHeight)
                })
            }

            ForEach(this.newsModel.newsData, (newsItem: NewsData) => {
                ListItem() {
                    NewsItem({ newsData: newsItem })
                }
                .height($r('app.float.news_list_height'))
                .backgroundColor($r('app.color.white'))
                .margin({ top: $r('app.float.news_list_margin_top') })
                .borderRadius(CommonConstant.NewsListConstant_ITEM_BORDER_RADIUS)
            }, (item: NewsData, index: number) => JSON.stringify(item) + index)
            ListItem() {
                if (this.newsModel.hasMore) {
                    LoadMoreLayout({
                        loadMoreLayoutClass: new CustomRefreshLoadLayoutClass(
                            this.newsModel.isVisiblePullUpLoad,
                            this.newsModel.pullUpLoadImage,
                            this.newsModel.pullUpLoadText,
                            this.newsModel.pullUpLoadHeight
                        )
                    })
                } else {
                    NoMoreLayout()
                }
            }
        }
        .width(CommonConstant.NewsListConstant_LIST_WIDTH)
        .height(CommonConstant.FULL_HEIGHT)
        .margin({
            left: CommonConstant.NewsListConstant_LIST_MARGIN_LEFT,
            right: CommonConstant.NewsListConstant_LIST_MARGIN_RIGHT
        })
        .edgeEffect(EdgeEffect.None)
        .onScrollIndex((start: number, end: number) => {
            this.newsModel.startIndex = start;
            this.newsModel.endIndex = end;
        })
    }

    @Builder LoadingLayout() {
        CustomRefreshLoadLayout({
            customRefreshLoadClass: new CustomRefreshLoadLayoutClass(
                true,
                $r('app.media.ic_pull_up_load'),
                $r('app.string.pull_up_load_text'),
                this.newsModel.pullDownRefreshHeight
            )
        })
    }

    @Builder FailLayout() {
        Image($r('app.media.none'))
            .height(CommonConstant.NewsListConstant_NONE_IMAGE_SIZE)
            .width(CommonConstant.NewsListConstant_NONE_IMAGE_SIZE)
        Text($r('app.string.page_none_msg'))
            .opacity(CommonConstant.NewsListConstant_NONE_TEXT_opacity)
            .fontSize(CommonConstant.NewsListConstant_NONE_TEXT_size)
            .fontColor($r('app.color.fontColor_text3'))
            .margin({ top: CommonConstant.NewsListConstant_NONE_TEXT_margin })
    }
}