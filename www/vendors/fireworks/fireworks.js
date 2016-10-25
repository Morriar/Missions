// Gladly taken and modified from http://codepen.io/sol0mka/details/AXRAkg/
'use strict';
var _extends = Object.assign || function (target) {
    for (var i = 1; i < arguments.length; i++) {
        if (window.CP.shouldStopExecution(2)) {
            break;
        }
        var source = arguments[i];
        for (var key in source) {
            if (window.CP.shouldStopExecution(1)) {
                break;
            }
            if (Object.prototype.hasOwnProperty.call(source, key)) {
                target[key] = source[key];
            }
        }
        window.CP.exitedLoop(1);
    }
    return target;
    window.CP.exitedLoop(2);
};

/* Update for material design's color palette
 *
 * #F44336
 * #E91E63
 * #9C27B0
 * #673AB7
 * #3F51B5
 * #2196F3
 * #03A9F4
 * #00BCD4
 * #009688
 * #4CAF50
 * #8BC34A
 * #CDDC39
 * #FFEB3B
 * #FFC107
 * #FF9800
 * #FF5722
 * #795548
 * #9E9E9E
 * #607D8B
 */

var COLORS = {
    RED: '#F44336',
    YELLOW: '#FFEB3B',
    BLACK: '#212121',
    WHITE: '#F5F5F5',
    VINOUS: '#880E4F'
};

var ALL_COLORS = [
	'#F44336',
	'#E91E63',
	'#9C27B0',
	'#673AB7',
	'#3F51B5',
	'#2196F3',
	'#03A9F4',
	'#00BCD4',
	'#009688',
	'#4CAF50',
	'#8BC34A',
	'#CDDC39',
	'#FFEB3B',
	'#FFC107',
	'#FF9800',
	'#FF5722',
	'#795548',
	'#9E9E9E',
	'#607D8B'
];

var burst1 = new mojs.Burst({
    left: 0,
    top: 0,
    count: 16,
    radius: { 50: 150 },
    children: {
        shape: 'line',
        stroke: ALL_COLORS,
        scale: 2,
        scaleX: { 1: 0 },
        degreeShift: 'rand(-90, 90)',
        radius: 'rand(20, 40)',
        delay: 'rand(0, 150)',
        isForce3d: true
    }
});
var largeBurst = new mojs.Burst({
    left: 0,
    top: 0,
    count: 6,
    radius: 0,
    angle: 45,
    radius: { 0: 550 },
    children: {
        shape: 'line',
        stroke: ALL_COLORS,
        scale: 2,
        scaleX: { 1: 0 },
        radius: 100,
        duration: 450,
        isForce3d: true,
        easing: 'cubic.inout'
    }
});
var CIRCLE_OPTS = {
    left: 0,
    top: 0,
    scale: { 0: 2 }
};
var largeCircle = new mojs.Shape(_extends({}, CIRCLE_OPTS, {
    fill: 'none',
    stroke: 'red',
    strokeWidth: 8,
    opacity: { 0.25: 0 },
    radius: 250,
    duration: 600
}));
var smallCircle = new mojs.Shape(_extends({}, CIRCLE_OPTS, {
    fill: 'red',
    opacity: { 0.5: 0 },
    radius: 60
}));

var getRandIntRange = function(min, max) {
	return Math.floor(Math.random() * (max - min + 1)) + min;
};

var launchSingleFirework = function () {

	var minX = 0;
	var minY = 0;
	var maxX = window.innerWidth;
	var maxY = window.innerHeight;

	var randX = getRandIntRange(minX, maxX);
	var randY = getRandIntRange(minY, maxY);

	var randColor = ALL_COLORS[getRandIntRange(0, ALL_COLORS.length)];

    burst1.tune({
        x: randX,
        y: randY
    }).generate().replay();
    largeBurst.tune({
        x: randX,
        y: randY
    }).replay();
    largeCircle.tune({
        x: randX,
        y: randY,
				stroke: randColor
    }).replay();
    smallCircle.tune({
        x: randX,
        y: randY,
				fill: randColor
    }).replay();
};

var launchFireworks = function () {
	$("body").animate({scrollTop: 0}, "slow");
	var count = getRandIntRange(8, 10);
	var delay = 500;

	for (var i = 0; i < count; i++) {
		setTimeout(launchSingleFirework, delay);
		delay += getRandIntRange(500, 1500);
	}
};

