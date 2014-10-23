//
//  Math.m
//  iMarch
//
//  Created by Justin Moore on 11/20/13.
//  Copyright (c) 2013 Justin Moore. All rights reserved.
//

#import "Math.h"

@implementation Math


/* =============================================================================
 Convert radians to degrees.
 ============================================================================ */
+ (float)radiansToDegrees:(float)radians {
    return radians * 180.0 / M_PI;
}

/* =============================================================================
 Convert degrees to radians.
 ============================================================================ */
+ (float)degreesToRadians:(float)degrees {
    return degrees * M_PI / 180.0;
}

/* =============================================================================
 Returns the distance of the x and y components (in a CGPoint) that a point is
 offset from another point.
 ============================================================================ */
+ (CGFloat)distanceFromPoint:(CGPoint)a toPoint:(CGPoint)b {
    CGFloat dx = a.x - b.x;
    CGFloat dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
}

/* =============================================================================
 Returns the Eudlidean distance that a point is offset from another point.
 ============================================================================ */
+ (CGPoint)offsetFromPoint:(CGPoint)a toPoint:(CGPoint)b {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

/* =============================================================================
 Returns an angle representing the direction of a second point relative to the
 first point. Will return an angle between -180 and +180. 0 is "east", positive
 angles are counterclockwise.
 ============================================================================ */
+ (CGFloat)bearingFromPoint:(CGPoint)a toPoint:(CGPoint)b {
    CGFloat angleRadians = (atan2((b.y - a.y), (b.x - a.x)));
    return [self radiansToDegrees:angleRadians];
}

/* =============================================================================
 Given a point, an angle from that point, and a distance, returns a new point.
 0 is "east", positive angles are counterclockwise.
 ============================================================================ */
+ (CGPoint)scalePointFromPoint:(CGPoint)origin distance:(CGFloat)distance angle:(CGFloat)angle scaleUP:(BOOL)scaleUP{
    float theta = [self degreesToRadians:angle];
    CGPoint result;
    if (scaleUP)
    {
        result.x = origin.x + distance * cos(theta);
        result.y = origin.y + distance * sin(theta);
    }
    else
    {
        result.x = origin.x - distance * cos(theta);
        result.y = origin.y - distance * sin(theta);
    }
    
    return result;
}

+ (CGPoint)movePointFromPoint:(CGPoint)origin distance:(CGFloat)distance angle:(CGFloat)angle
{
    float theta = [self degreesToRadians:angle];
    CGPoint result;
    result.x = origin.x + distance * cos(theta);
    result.y = origin.y + distance * sin(theta);
    return result;
}

/* =============================================================================
 Checks to see if an an angle is within the variance passed in. The variance
 value is on each side of the reference, so the total acceptable range will be
 double the variance. Expects angles in the range of -180 to +180 and a
 variance less than 180 (over 180 would match any angle).
 ============================================================================ */
+ (BOOL)angle:(float)angleToCheck isInRangeOfAngle:(float)referenceAngle withVariance:(float)variance {
    NSAssert1(angleToCheck >= -180.0 && angleToCheck <= 180.0, @"angle:isInRangeOfAngle:withVariance: angle %f is out of allowed range -180 to +180.", angleToCheck);
    NSAssert1(referenceAngle >= -180.0 && referenceAngle <= 180.0, @"angle:isInRangeOfAngle:withVariance: reference angle %f is out of allowed range -180 to +180.", referenceAngle);
    NSAssert1(variance < 180.0, @"angle:isInRangeOfAngle:withVariance: variance %f must be less than 180.", variance);
    float min = referenceAngle - fabs(variance);
    float max = referenceAngle + fabs(variance);
    
    /* --- Deal with wrap-around negative values, rotate everything +180.0. --- */
    if (min < -180.0) {
        angleToCheck += 180.0;
        min += 180.0;
        max += 180.0;
    }
    
    /* --- Deal with wrap-around positive values, rotate everything -180.0. --- */
    if (max > 180.0) {
        angleToCheck -= 180.0;
        min -= 180.0;
        max -= 180.0;
    }
    
    return (angleToCheck >= min && angleToCheck <= max);
}

/* =============================================================================
 Calculates the signed difference between two angles, deals with wrap-around
 issues. Expects angles in the range of -180 to +180.
 ============================================================================ */
+ (float)deltaFromAngle:(float)angleA toAngle:(float)angleB {
    NSAssert1(angleA >= -180.0 && angleA <= 180.0, @"deltaFromAngle:toAngle: first angle %f is out of allowed range -180 to +180.", angleA);
    NSAssert1(angleB >= -180.0 && angleB <= 180.0, @"deltaFromAngle:toAngle: second angle %f is out of allowed range -180 to +180.", angleB);
    
    float delta = angleB - angleA;
    
    if (delta > 180.0) {
        delta -= 360.0;
    }
    
    if (delta < -180.0) {
        delta += 360.0;
    }
    
    return delta;
}

/* =============================================================================
 Normalize an angle to >= 0.0 and < 360.0.
 ============================================================================ */
+ (float)normalize0To360Angle:(float)angle {
    float normalizedAngle = fmodf(angle, 360.0);
    if (normalizedAngle >= 360.0) {
        normalizedAngle -= 360.0;
    } else if (normalizedAngle < 0.0) {
        normalizedAngle += 360.0;
    }
    return fabsf(normalizedAngle);
}

/* =============================================================================
 Normalize an angle to >= -180.0 and < 180.0.
 ============================================================================ */
+ (float)normalizeMinus180ToPlus180Angle:(float)angle {
    float normalizedAngle = [self normalize0To360Angle:angle];
    if (normalizedAngle > 180.0) {
        normalizedAngle -= 360.0;
    }
    return normalizedAngle;
}

/* =============================================================================
 Find the smallest angle between two signed angles between -180 and +180. For
 example, given the angles a1 = +175 and a2 = -175, it should return -10.
 ============================================================================ */
+ (float)smallestAngleFromAngle1:(float)a1 angle2:(float)a2 {
    float angle = fmodf(a2 - a1, 360.0);
    
    if (angle < 0.0) {
        angle += 360.0;
    }
    
    if (angle > 180.0) {
        angle -= 360.0;
    }
    
    return angle;
}

@end
