import { CommonConstant } from '../common/constant/CommonConstant'
import { NewsData, NewsFile } from '../viewmodel/NewsViewModel'

@Component
export default struct NewsItem {
    private newsData: NewsData = new NewsData()

    build() {
        Column() {
            Row() {
                Image($r('app.media.news'))
                    .width(CommonConstant.NewsTitle_IMAGE_WIDTH)
                    .height($r('app.float.news_title_image_height'))
                    .objectFit(ImageFit.Fill)
                Text(this.newsData.title)
                    .fontSize(CommonConstant.NewsTitle_TEXT_FONT_SIZE)
                    .fontColor($r('app.color.fontColor_text'))
                    .fontWeight(CommonConstant.NewsTitle_TEXT_FONT_WEIGHT)
                    .width(CommonConstant.NewsTitle_TEXT_WIDTH)
                    .margin({ left: CommonConstant.NewsTitle_TEXT_MARGIN_LEFT })
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .maxLines(1)

            }
            .alignItems(VerticalAlign.Center)
            .height($r('app.float.news_title_row_height'))
            .margin({
                top: $r('app.float.news_title_row_margin_top'),
                left: CommonConstant.NewsTitle_IMAGE_MARGIN_LEFT
            })


            Text(this.newsData.content)
                .fontSize(CommonConstant.NewsContent_FONT_SIZE)
                .fontColor($r('app.color.fontColor_text'))
                .height(CommonConstant.NewsContent_HEIGHT)
                .width(CommonConstant.NewsContent_WIDTH)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .maxLines(CommonConstant.NewsContent_MAX_LINES)
                .margin({ left: CommonConstant.NewsContent_MARGIN_LEFT, top: CommonConstant.NewsContent_MARGIN_TOP })
            Grid() {
                ForEach(this.newsData.imagesUrl, (itemImg: NewsFile) => {
                    GridItem() {
                        Image(CommonConstant.SERVER + itemImg.url)
                            .objectFit(ImageFit.Cover)
                            .borderRadius(CommonConstant.NewsGrid_IMAGE_BORDER_RADIUS)
                    }
                }, (item: NewsFile) => JSON.stringify(item))
            }
            .margin({ left: CommonConstant.NewsGrid_MARGIN_LEFT, top: CommonConstant.NewsGrid_MARGIN_TOP,
                right: CommonConstant.NewsGrid_MARGIN_RIGHT })
            .width(CommonConstant.NewsGrid_WIDTH)
            .height(CommonConstant.NewsGrid_HEIGHT)
            .columnsTemplate(CommonConstant.NewsGrid_ROWS_TEMPLATE.repeat(this.newsData.imagesUrl.length))
            .columnsGap(CommonConstant.NewsGrid_COLUMNS_GAP)
            .rowsTemplate(CommonConstant.NewsGrid_ROWS_TEMPLATE)

            Text(this.newsData.source)
                .fontSize(CommonConstant.NewsSource_FONT_SIZE)
                .fontColor($r('app.color.fontColor_text2'))
                .height(CommonConstant.NewsSource_HEIGHT)
                .width(CommonConstant.NewsSource_WIDTH)
                .maxLines(CommonConstant.NewsSource_MAX_LINES)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ left: CommonConstant.NewsSource_MARGIN_LEFT, top: CommonConstant.NewsSource_MARGIN_TOP })

        }
        .alignItems(HorizontalAlign.Start)
    }
}