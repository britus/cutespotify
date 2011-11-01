/****************************************************************************
**
** Copyright (c) 2011 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Yoann Lopes (yoann.lopes@nokia.com)
**
** This file is part of the MeeSpot project.
**
** Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions
** are met:
**
** Redistributions of source code must retain the above copyright notice,
** this list of conditions and the following disclaimer.
**
** Redistributions in binary form must reproduce the above copyright
** notice, this list of conditions and the following disclaimer in the
** documentation and/or other materials provided with the distribution.
**
** Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its
** contributors may be used to endorse or promote products derived from
** this software without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
** FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
** TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
** PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
** LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
** NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
** SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
**
****************************************************************************/

import QtQuick 1.1
import com.meego 1.0
import "UIConstants.js" as UI

Item {
    id: scrollbar

    property ListView listView
    property int scrollDecoratorRightMargin: 0

    anchors.right: listView.right
    anchors.rightMargin: -UI.MARGIN_XLARGE
    anchors.top: listView.top
    anchors.bottom: listView.bottom
    width: 72

    Image {
        id: fastscrollbar
        anchors.fill: parent
        source: "image://theme/meegotouch-fast-scroll-rail-inverted"
        opacity: 0
        visible: listView.count >= 25

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "image://theme/meegotouch-fast-scroll-handle-inverted"
            y: Math.max(0, Math.min(parent.height - height, (listView.contentY / (listView.contentHeight - listView.height / 2)) * parent.height))
        }

        states: State {
            name: "visible"
            when: fastscrollbar.visible && (listView.moving || mousearea.pressed)
            PropertyChanges {
                target: fastscrollbar
                opacity: 1
            }
        }

        transitions: Transition {
            from: "visible"; to: ""
            SequentialAnimation {
                PauseAnimation { duration: 700 }
                NumberAnimation {
                    properties: "opacity"
                    duration: 200
                }
            }
        }

        Timer {
            interval: 50
            running: mousearea.pressed
            repeat: true
            onTriggered: listView.positionViewAtIndex((mousearea.mouseY / parent.height) * listView.count, ListView.Beginning)
        }

        MouseArea {
            id: mousearea
            anchors.fill: parent
            enabled: fastscrollbar.opacity > 0
            onPressed: listView.positionViewAtIndex((mouse.y / height) * listView.count, ListView.Beginning)
            onPositionChanged: {
                if (mouse.y < 40 || mouse.y > height - 40)
                    listView.positionViewAtIndex((mouse.y / height) * listView.count, ListView.Beginning)
            }
        }
    }

    ScrollDecorator {
        parent: listView
        visible: !fastscrollbar.visible
        anchors.rightMargin: scrollbar.scrollDecoratorRightMargin

        Component.onCompleted: flickableItem = listView
    }

}
