#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>
#define PI 3.141592653589
#define TWO_PI 6.28318530718

extern "C" { namespace coreimage {

    float4 conicGradient(
                         sample_t color1,
                         sample_t color2,
                         float4 rect,
                         float2 centerPoint,
                         float startAngle,
                         float endAngle,
                         destination dest) {
        
        float2 st = dest.coord() / rect.wz; // normalize coordinate
        float2 toCenter = centerPoint - st;
        float angle = atan2(toCenter.y, toCenter.x) + PI; // 0...2𝛑

        // percent of transition from one color to another
        float3 pct = float3((angle - startAngle) / (endAngle - startAngle));
        pct = smoothstep(0.0, 1.0, pct);
        
        float3 color = mix(color1.rgb, color2.rgb, pct);

        return float4(color, 1.0);
    }

    
    float4 sector(float4 rect, float startAngle, float endAngle, destination dest) {

        float radius = 0.5;
        float2 st = dest.coord() / rect.wz;
        float2 toCenter = float2(0.5) - st;
        float theta = atan2(toCenter.y, toCenter.x) + PI;
        float r = length(toCenter);
        
        // the constant thickness for the antialias edges
        float limit = radius / rect.w;
        
        if (startAngle <= theta && theta <= endAngle && r <= radius) {
            float normR = (r - (radius - limit)) / limit;
            float step = smoothstep(1.0, 0.0, normR);
            return float4(float3(step), 1.0);
        } else {
            return float4(0.0);
        }
    }

}}
