//
//  Transforms.h
//  Raymarching
//
//  Created by Maciek Czarnik on 22/04/2024.
//

#ifndef Transforms_h
#define Transforms_h

using namespace metal;

float3 rotate(float3 p, float3 axis, float angle);

float3x3 homogeneous(float2x2 mat);

float3x3 translateY(float y);
float3x3 translate(float2 xy);

float2x2 scale(float2 s);
float2x2 scaleY(float y);

float2 transform(float2 p, float3x3 matrix);
float3x3 inverse(float3x3 m);

#endif /* Transforms_h */
