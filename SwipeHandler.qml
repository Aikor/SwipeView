import QtQuick 2.0

MouseArea{
    id: root

    property int oldX: mouseX;
    property int swipeOffset: parent.width/2;
    property int originX: mouseX;

    property var gestureStartTime;
    property bool gestureStarted: false;

    signal swipeEnded(var diff);
    signal swipeContinues(var diff);

    anchors.fill: parent

    onReleased: {
        if( gestureStarted ) {
            root.swipeEnded(0);
            resetGesture();
        }
    }

    onPressed: {
        gestureStarted =  true;
    }

    onMouseXChanged: {
        if( mouseX < parent.x || mouseX > parent.width || gestureStarted == false ) {
            return;
        }

        if( originX == 0 ) {
            originX = mouseX; oldX = mouseX;
            return;
        }

        var diff = (oldX - mouseX);
        if(handleFlick(diff)){
            return;
        }
        if( haldleDrag(mouseX, diff)){
            return;
        }

        oldX = mouseX;
        root.swipeContinues(diff);
    }

    function resetGesture() {
        originX = 0; oldX = 0;
        gestureStarted =  false;
    }

    function haldleDrag(xPos,xPosDiff){
        if(xPosDiff < 0) {
            if( Math.abs(originX-xPos)  > swipeOffset ){
                root.swipeEnded(xPosDiff);
                resetGesture();
                return true;
            }
        } else {
            if( Math.abs(originX-xPos) >  swipeOffset ){
                root.swipeEnded(xPosDiff);
                resetGesture();
                return true;
            }
        }
        return false;
    }

    function handleFlick(xPosDiff){
        var now = new Date();
        var timeDiff = now - gestureStartTime;

        //high velocity and large diff between start end point
        if(timeDiff < 40 && Math.abs(xPosDiff) > 10 ){
            if(xPosDiff < 0) {
                root.swipeEnded(xPosDiff);
                resetGesture();
                return true;
            } else {
                root.swipeEnded(xPosDiff);
                resetGesture();
                return true;
            }
        }
        return false;
    }
}
