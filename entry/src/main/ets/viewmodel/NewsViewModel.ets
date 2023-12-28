import { CommonConstant } from '../common/constant/CommonConstant';
import { httpRequestGet } from '../common/utils/HttpUtil';

export class NewsData {
    title: string = ''
    content: string = ''
    imagesUrl: Array<NewsFile> = [new NewsFile()];
    source: string = '';
}

export class NewsFile {
    id: number = 0
    url: string = ''
    type: number = 0
    newsId: number = 0
}

@Observed
export class CustomRefreshLoadLayoutClass {
    isVisible: boolean;
    imageSrc: Resource;
    textValue: Resource;
    heightValue: number;

    constructor(isVisible: boolean, imageSrc: Resource, textValue: Resource, heightValue: number) {
        this.isVisible = isVisible;
        this.imageSrc = imageSrc;
        this.textValue = textValue;
        this.heightValue = heightValue;
    }
}


export class NewsTypeBean {
    id: number = 0;
    name: ResourceStr = '';
}

class NewsViewModel {
    getNewsTypeList(): Promise<NewsTypeBean[]> {
        return new Promise((resolve: Function) => {
            let url = `${CommonConstant.SERVER}/${CommonConstant.GET_NEWS_TYPE}`
            httpRequestGet(url).then((data: ResponseResult) => {
                if (data.code === CommonConstant.SERVER_CODE_SUCCESS) {
                    resolve(data.data)
                } else {
                    resolve(CommonConstant.TabBars_DEFAULT_NEWS_TYPES)
                }
            }).catch(() => {
                resolve(CommonConstant.TabBars_DEFAULT_NEWS_TYPES)
            })

        })
    }

    getDefaultTypeList() {
        return CommonConstant.TabBars_DEFAULT_NEWS_TYPES;
    }

    getNewsList(currentPage: number, pageSize: number, path: string): Promise<NewsData[]> {
        return new Promise((resolve: Function, reject: Function) => {
            let url = `${CommonConstant.SERVER}/${path}`;
            url += '?currentPage=' + currentPage + '&pageSize=' + pageSize;
            httpRequestGet(url).then((data: ResponseResult) => {
                if (data.code === CommonConstant.SERVER_CODE_SUCCESS) {
                    resolve(data.data)
                } else {
                    reject($r('app.string.page_none_msg'));
                }
            }).catch((err: Error) => {
                reject($r('app.string.http_error_message'));

            })

        })
    }
}

export class ResponseResult {
    code: string;
    msg: string | Resource;
    data: string | object | ArrayBuffer

    constructor() {
        this.code = ''
        this.msg = ''
        this.data = ''
    }
}

let newsViewModel = new NewsViewModel();

export default newsViewModel as NewsViewModel;
