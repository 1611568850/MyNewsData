import http from '@ohos.net.http';
import { ResponseResult } from '../../viewmodel/NewsViewModel'
import { CommonConstant, ContentType } from '../constant/CommonConstant';

export function httpRequestGet(url: string): Promise<ResponseResult> {
    let httpRequest = http.createHttp();
    let responseResult = httpRequest.request(url, {
        method: http.RequestMethod.GET,
        readTimeout: CommonConstant.HTTP_READ_TIMEOUT,
        header: {
            'Content-Type': ContentType.JSON
        },
        connectTimeout: CommonConstant.HTTP_READ_TIMEOUT,
        extraData: {}
    })
    let serverData: ResponseResult = new ResponseResult();
    return responseResult.then((value: http.HttpResponse) => {
        if (value.responseCode === CommonConstant.HTTP_CODE_200) {
            let result = `${value.result}`
            let resultJson: ResponseResult = JSON.parse(result)
            if (resultJson.code === CommonConstant.SERVER_CODE_SUCCESS) {
                serverData.data = resultJson.data
            }
            serverData.msg = resultJson.msg
            serverData.code = resultJson.code
        } else {
            serverData.msg = `${$r('app.string.http_error_message')}&${value.responseCode}`;
        }
        return serverData;
    }).catch(() => {
        serverData.msg = $r('app.string.http_error_message')
        return serverData
    })
}