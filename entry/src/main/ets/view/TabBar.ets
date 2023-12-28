import { CommonConstant } from '../common/constant/CommonConstant'
import NewsViewModel, { NewsTypeBean } from '../viewmodel/NewsViewModel'
import NewsList from './NewsList'

@Component
export default struct TabBar {
    @State tabBarArray: NewsTypeBean[] = NewsViewModel.getDefaultTypeList()
    @State currentIndex: number = 0;
    @State currentPage: number = 1

    @Builder TabBuilder(index: number) {
        Column() {
            Text(this.tabBarArray[index].name)
                .height(CommonConstant.FULL_HEIGHT)
                .fontSize(this.currentIndex === index ? CommonConstant.TabBars_SELECT_TEXT_FONT_SIZE : CommonConstant.TabBars_UN_SELECT_TEXT_FONT_SIZE)
                .fontWeight(this.currentIndex === index ? CommonConstant.TabBars_SELECT_TEXT_FONT_WEIGHT : CommonConstant.TabBars_UN_SELECT_TEXT_FONT_WEIGHT)
                .margin({
                    left: CommonConstant.TabBars_HORIZONTAL_PADDING,
                    right: CommonConstant.TabBars_HORIZONTAL_PADDING
                })
                .fontColor($r('app.color.fontColor_text3'))


        }
    }

    aboutToAppear() {
        NewsViewModel.getNewsTypeList().then((typeList: NewsTypeBean[]) => {
            this.tabBarArray = typeList
        }).catch((typeList: NewsTypeBean[]) => {
            this.tabBarArray = typeList
        })
    }

    build() {
        Tabs() {
            ForEach(this.tabBarArray, (tabsItem: NewsTypeBean) => {
                TabContent() {
                    Column() {
                        NewsList({ currentIndex: $currentIndex })
                    }
                }
                .tabBar(this.TabBuilder(tabsItem.id))
            }, (item: NewsTypeBean) => JSON.stringify(item))
        }
        .barHeight(CommonConstant.TabBars_BAR_HEIGHT)
        .barMode(BarMode.Scrollable)
        .barWidth(CommonConstant.TabBars_BAR_WIDTH)
        .vertical(false)
        .onChange((index: number) => {
            this.currentIndex = index;
            this.currentPage = 1;
        })

    }
}