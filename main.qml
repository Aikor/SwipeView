import QtQuick 2.10
import QtQuick.Window 2.10

Window {
    visible: true
    width: root.width
    height: root.height
    minimumWidth: width
    minimumHeight: height
    maximumWidth: width
    maximumHeight: height
    Rectangle {
        id: root
        width: 200
        height: 300

        property var delegate: comp;

        property var centralView;
        property var nextView;
        property var prevView;

        focus: true

        Component.onCompleted: {
            var colors = ["red","blue","green"];
            var objs = [];
            for(var i =0; i < 3; ++i){
                var obj = comp.createObject(root);
                obj.text = i+1;
                obj.color = colors[i];
                objs.push(obj);
            }

            centralView = objs[0]
            nextView = objs[1]
            prevView = objs[2]

            setViewPos();
        }

        function setViewPos(oldX){
            centralView.animate(50,0);
            nextView.animate(50,root.width);
            prevView.animate(50,-root.width);

            centralView.z = 1;
            nextView.z = 0;
            prevView.z = 0;
        }

        Keys.onRightPressed: {
            var tempView = centralView;
            centralView = prevView;
            prevView = nextView;
            nextView = tempView;

            centralView.animate(150,0);
            nextView.animate(150,root.width);
            prevView.x = -width
        }

        Keys.onLeftPressed: {
            var tempView = centralView;
            centralView = nextView;
            nextView = prevView;
            prevView = tempView;

            centralView.animate(150,0);
            prevView.animate(150,-root.width);
            nextView.x = width
        }

        SwipeHandler{
            onSwipeEnded: {
                if(diff === 0) {
                    root.setViewPos();
                    return;
                }

                var tempView = root.centralView;
                if(diff < 0) {
                    root.centralView = root.prevView;
                    root.prevView = root.nextView;
                    root.nextView = tempView;
                } else {
                    root.centralView = root.nextView;
                    root.nextView = root.prevView;
                    root.prevView = tempView;
                }
                root.setViewPos();
            }

            onSwipeContinues: {
                root.centralView.x = root.centralView.x - diff;
                if(diff < 0) {
                    root.prevView.x = root.prevView.x  + Math.abs(diff*1.6);
                    root.prevView.z = 1
                    root.centralView.z = 0;
                } else {
                    root.nextView.x = root.nextView.x - Math.abs(diff*1.6) ;
                    root.nextView.z = 1
                    root.centralView.z = 0;
                }
            }
        }

        Component{
            id: comp
            Rectangle{
                id: rect
                property alias text: label.text

                width: parent.width; height: parent.height
                Text{
                    id: label; anchors.centerIn: parent
                }

                function animate(duration, to){
                    anim.to = to; anim.duration = duration
                    anim.running = true
                }

                PropertyAnimation{
                    id: anim; target:rect; property: "x";duration: 50
                }
            }
        }
    }
}
