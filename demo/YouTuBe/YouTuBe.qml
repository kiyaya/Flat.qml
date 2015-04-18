import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtMultimedia 5.4
import FlatUI 2.0
import FlatUI.Private 2.0
import "./YouTuBe"

MyWindow{
    id:window
    title:"VideoPlayer"
    width: 730
    height: 480

    VideoPlayer {
        id:video
        sourceUrl: "" //YouTuBe.youTuBeVideoDownloadUrl
        anchors.fill: parent
        showState: window.showState
        MouseArea{
            anchors.fill: parent
            acceptedButtons: Qt.AllButtons
            preventStealing:true

            onClicked: if(mouse.button == Qt.RightButton ) menu.popup();
            onDoubleClicked: {
                if(mouse.button == Qt.LeftButton) {
                    window.showState <= FlatGlobal.showNormal ?
                                window.showState = FlatGlobal.showFullScreen :
                                window.showState = FlatGlobal.showNormal;
                }
            }
        }
    }

    FlatMenu{
        // 在全屏下无法显示菜单
        id:menu
        MenuItem{
            text:"play"
            onTriggered:video.play();
        }
        MenuItem{
            text:"pause"
            onTriggered:video.pause();
        }
        MenuItem{
            text:"stop"
            onTriggered:video.stop();
        }
        MenuSeparator { }

        MenuItem{
            text:video.loops == -1 ?"单曲循环":"播放一次"
            onTriggered:video.loops == -1 ? video.loops = 1 : video.loops = -1;
        }
    }


    SiderBar{
        id:siderBar;
        header:Item{
            width: siderBar.width
            height: FlatGlobal.sizeHuge
        }
        model: VisualItemModel {
            // Settings UI
            Item{
                width: siderBar.width
                height: siderBar.height
                Column {
                    anchors.horizontalCenter:  parent.horizontalCenter
                    anchors.margins: 10
                    spacing:5
                    Item{
                        height: 10
                        width:parent.width
                    }

                    FlatTextField{
                        id:youtubeUrl
                        width: 180
                        size:FlatGlobal.sizeExtraSmall
                        type:FlatGlobal.typeDefault
                        placeholderText:"YouTube url"
                    }
                    FlatButton{
                        size:FlatGlobal.sizeExtraSmall
                        type:FlatGlobal.typeSuccess
                        text:"play"
                        width:180
                        onClicked: {
                            setYouTuBeUrl(youtubeUrl.text);
                            YouTuBe.finished.connect(function(){
                                YouTuBe.finished.disconnect(arguments.callee);
                                // console.debug(YouTuBe.youTuBeVideoDownloadUrl);

                                video.sourceUrl =
                                        Qt.binding(function(){
                                            return YouTuBe.youTuBeVideoDownloadUrl;
                                        });
                            });
                            controlSiderBar();
                        }
                    }
                    FlatButton{
                        size:FlatGlobal.sizeExtraSmall
                        type:FlatGlobal.typeInfo
                        text:"download"
                        width:180
                        onClicked: {
                            setYouTuBeUrl(youtubeUrl.text);
                            YouTuBe.finished.connect(function(){
                                YouTuBe.finished.disconnect(arguments.callee);
                                YouTuBe.downloadYouTubeVideoByBroswer();
                            });
                            controlSiderBar();
                        }
                    }
                }
            }
        }
    }
}
