//
//  Math.h
//  iMarch
//
//  Created by Justin Moore on 11/20/13.
//  Copyright (c) 2013 Justin Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Math : NSObject

/* =============================================================================
 Convert radians to degrees.
 ============================================================================ */
+ (float)radiansToDegrees:(float)radians;

/* =============================================================================
 Convert degrees to radians.
 ============================================================================ */
+ (float)degreesToRadians:(float)degrees;

/* =============================================================================
 Returns the distance of the x and y components (in a CGPoint) that a point is
 offset from another point.
 ============================================================================ */
+ (CGFloat)distanceFromPoint:(CGPoint)a toPoint:(CGPoint)b;

/* =============================================================================
 Returns the Eudlidean distance that a point is offset from another point.
 ============================================================================ */
+ (CGPoint)offsetFromPoint:(CGPoint)a toPoint:(CGPoint)b;

/* =============================================================================
 Returns an angle representing the direction of a second point relative to the
 first point. Will return an angle between -180 and +180. 0 is "east", positive
 angles are counterclockwise.
 ============================================================================ */
+ (CGFloat)bearingFromPoint:(CGPoint)a toPoint:(CGPoint)b;

/* =============================================================================
 Given a point, an angle from that point, and a distance, returns a new point.
 0 is "east", positive angles are counterclockwise.
 ============================================================================ */
+ (CGPoint)scalePointFromPoint:(CGPoint)origin distance:(CGFloat)distance angle:(CGFloat)angle scaleUP:(BOOL)scaleUP;
+ (CGPoint)movePointFromPoint:(CGPoint)origin distance:(CGFloat)distance angle:(CGFloat)angle;
/* =============================================================================
 Checks to see if an an angle is within the variance passed in. The variance
 value is on each side of the reference, so the total acceptable range will be
 double the variance. Expects angles in the range of -180 to +180 and a
 variance less than 180 (over 180 would match any angle).
 ============================================================================ */
+ (BOOL)angle:(float)angleToCheck isInRangeOfAngle:(float)referenceAngle withVariance:(float)variance;

/* =============================================================================
 Calculates the signed difference between two angles, deals with wrap-around
 issues. Expects angles in the range of -180 to +180.
 ============================================================================ */
+ (float)deltaFromAngle:(float)angleA toAngle:(float)angleB;

/* =============================================================================
 Normalize an angle to >= 0.0 and < 360.0.
 ============================================================================ */
+ (float)normalize0To360Angle:(float)angle;

/* =============================================================================
 Normalize an angle to >= -180.0 and < 180.0.
 ============================================================================ */
+ (float)normalizeMinus180ToPlus180Angle:(float)angle;

/* =============================================================================
 Find the smallest angle between two signed angles between -180 and +180. For
 example, given the angles a1 = +175 and a2 = -175, it should return -10.
 ============================================================================ */
+ (float)smallestAngleFromAngle1:(float)a1 angle2:(float)a2;

@end
