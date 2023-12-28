import { CommonConstant } from '../common/constant/CommonConstant';
import TabBar from '../view/TabBar';

@Entry
@Component
struct Index {
    @State message: string = 'Hello World'

    build() {
        Column() {
            TabBar()
        }
        .width(CommonConstant.FULL_WIDTH)
        .backgroundColor($r('app.color.listColor'))
        .justifyContent(FlexAlign.Center)
    }
}