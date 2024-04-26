//
//  Angle.metal
//  LaciFisheye
//
//  Created by Maciek Czarnik on 26/04/2024.
//

#include <metal_stdlib>
using namespace metal;

float toMinusPlusPi(float angle) {
  if( angle > M_PI_F ) {
    return -(2*M_PI_F - angle);
  } else {
    return angle;
  }
}

float to2Pi(float angle) {
  if( angle < 0 ) {
    return 2*M_PI_F + angle;
  } else {
    return angle;
  }
}
