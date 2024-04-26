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

struct PolarCoordinate {
  float r;
  float theta;
  
  float2 cartesian() {
    return float2(
      r*cos(theta),
      r*sin(theta)
    );
  }
};

PolarCoordinate polar(float2 p) {
  return PolarCoordinate {
    .r = length(p),
    .theta = atan2(p.y, p.x)
  };
}

[[ stitchable ]] half4 laci(
  float2 position,
  SwiftUI::Layer image,
  float4 boundingRect
) {
  float aspectRatio = boundingRect.z / boundingRect.w;
  float3x3 normalize = translate(float2(-aspectRatio, 1.)) * homogeneous(scale(2 / boundingRect.w) * scale(float2(1, -1)));
  position = transform(position, normalize);
  position.x /= aspectRatio;
  PolarCoordinate polarPosition = polar(position);
  
  float rectExtentX;
  float rectExtentY;
  
  if( int(ceil((polarPosition.theta + M_PI_4_F + M_PI_F) / M_PI_2_F)) % 2 == 1 ) {
    //left & right
    rectExtentX = 1;
    rectExtentY = tan(polarPosition.theta);
  } else {
    //top & bottom
    rectExtentY = 1;
    rectExtentX = 1 / tan(polarPosition.theta);
  }
  
  float2 rectExtentPosition = float2(rectExtentX, rectExtentY);
  PolarCoordinate polarRectExtentPosition = polar(rectExtentPosition);
  polarPosition.r /= polarRectExtentPosition.r;
  
  position = polarPosition.cartesian();
  return image.sample(transform(position, inverse(normalize)));
}
