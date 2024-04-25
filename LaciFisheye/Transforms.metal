//
//  Transforms.metal
//  Raymarching
//
//  Created by Maciek Czarnik on 22/04/2024.
//

#include <metal_stdlib>
using namespace metal;

float4x4 rotationMatrix(float3 axis, float angle) {
  axis = normalize(axis);
  float s = sin(angle);
  float c = cos(angle);
  float ic = 1.0 - c;
  
  return float4x4(
    ic * axis.x * axis.x + c,          ic * axis.x * axis.y - axis.z * s, ic * axis.z * axis.x + axis.y * s, 0.0,
    ic * axis.x * axis.y + axis.z * s, ic * axis.y * axis.y + c,          ic * axis.y * axis.z - axis.x * s, 0.0,
    ic * axis.z * axis.x - axis.y * s, ic * axis.y * axis.z + axis.x * s, ic * axis.z * axis.z + c,          0.0,
    0.0,                               0.0,                               0.0,                               1.0
  );
}

float3 rotate(float3 p, float3 axis, float angle) {
  return (float4(p, 1) * rotationMatrix(axis, angle)).xyz;
}

float3x3 homogeneous(float2x2 mat) {
  return float3x3(
    float3(mat[0], 0),
    float3(mat[1], 0),
    float3(0, 0, 1)
  );
}

float3 homogeneousDisplacement(float2 f) {
  return float3(f, 0);
}

float3 homogeneousPosition(float2 p) {
  return float3(p, 1);
}

float2x2 scale(float2 s) {
  return float2x2(
    s.x, 0,
    0, s.y
  );
}

float3x3 translateY(float y) {
  return float3x3(
    1, 0, 0,
    0, 1, 0,
    0, y, 1
  );
}

float3x3 translateX(float x) {
  return float3x3(
    1, 0, 0,
    0, 1, 0,
    x, 0, 1
  );
}

float3x3 translate(float2 xy) {
  return float3x3(
    1,    0,    0,
    0,    1,    0,
    xy.x, xy.y, 1
  );
}

float2x2 scaleX(float x) {
  return scale(float2(x, 1));
}

float2x2 scaleY(float y) {
  return scale(float2(1, y));
}

float2 transform(float2 p, float3x3 homogeneousMatrix) {
  return (homogeneousMatrix * homogeneousPosition(p)).xy;
}

float3x3 inverse(float3x3 m) {
  float a00 = m[0][0], a01 = m[0][1], a02 = m[0][2];
  float a10 = m[1][0], a11 = m[1][1], a12 = m[1][2];
  float a20 = m[2][0], a21 = m[2][1], a22 = m[2][2];

  float b01 = a22 * a11 - a12 * a21;
  float b11 = -a22 * a10 + a12 * a20;
  float b21 = a21 * a10 - a11 * a20;

  float det = a00 * b01 + a01 * b11 + a02 * b21;

  return float3x3(
    b01, (-a22 * a01 + a02 * a21), (a12 * a01 - a02 * a11),
    b11, (a22 * a00 - a02 * a20), (-a12 * a00 + a02 * a10),
    b21, (-a21 * a00 + a01 * a20), (a11 * a00 - a01 * a10)
  ) / det;
}
