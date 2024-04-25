//
//  Laci.metal
//  LaciFisheye
//
//  Created by Maciek Czarnik on 25/04/2024.
//

#include <SwiftUI/SwiftUI.h>
#include <metal_stdlib>
using namespace metal;

#include "Transforms.h"

float toMinusPlusPi(float angle) {
  if( angle > M_PI_F ) {
    return -(2*M_PI_F - angle);
  } else {
    return angle;
  }
}
struct PolarCoordinate {
  float r;
  float theta;
  
  float2 cartesian() {
    float t = toMinusPlusPi(theta);
    return float2(
      r*cos(t),
      r*sin(t)
    );
  }
};

float to2Pi(float angle) {
  if( angle < 0 ) {
    return 2*M_PI_F + angle;
  } else {
    return angle;
  }
}

PolarCoordinate polar(float2 p) {
  return PolarCoordinate {
    .r = length(p),
    .theta = to2Pi(atan2(p.y, p.x))
  };
}

[[ stitchable ]] half4 laci(
  float2 position,
  SwiftUI::Layer image,
  float4 boundingRect
) {
  float3x3 normalize = translate(float2(-boundingRect.z / boundingRect.w, 1.)) * homogeneous(scale(2 / boundingRect.w) * scale(float2(1, -1)));
  position = transform(position, normalize);
  PolarCoordinate polarPosition = polar(position);
  
  float horizontalSize = boundingRect.z / boundingRect.w;
  
  float rectExtentX;
  float rectExtentY;
  
  if( polarPosition.theta > polar(float2(1,-1)).theta || polarPosition.theta < polar(float2(1,1)).theta ) {
    //right side
    rectExtentX = horizontalSize;
    rectExtentY = tan(polarPosition.theta) * rectExtentX;
  } else if( polarPosition.theta < polar(float2(-1,1)).theta && polarPosition.theta > polar(float2(1,1)).theta) {
    //top side
    rectExtentY = 1;
    rectExtentX = rectExtentY / tan(polarPosition.theta);
  } else if( polarPosition.theta < polar(float2(-1,-1)).theta ) {
    //left side
    rectExtentX = -horizontalSize;
    rectExtentY = tan(polarPosition.theta) * rectExtentX;
  } else {
    // bottom side
    rectExtentY = -1;
    rectExtentX = rectExtentY / tan(polarPosition.theta);
  }
  
  float2 rectExtentPosition = float2(rectExtentX, rectExtentY);
  PolarCoordinate polarRectExtentPosition = polar(rectExtentPosition);
  polarPosition.r /= polarRectExtentPosition.r;
  
  position = polarPosition.cartesian();
  return image.sample(transform(position, inverse(normalize)));
}

