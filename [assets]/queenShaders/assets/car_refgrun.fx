float sSparkleSize = 1;
float bumpSize = 3;

float2 uvMul = float2(1,1);
float2 uvMov = float2(0,0);

float brightnessFactor = 0;
float transFactor = 0.13;
float alphaFactor = 1;

float minZviewAngleFade = 0.1;
float sNormZ = 0;
float sRefFlan = 0.2;
float sAdd = 0.1;  
float sMul = 1.1; 
float sCutoff : CUTOFF = 0;         // 0 - 1
float sPower : POWER  = 20;            // 1 - 5 20
float sNorFacXY = 0.25;
float sNorFacZ = 1;

float gFilmDepth = 0; // 0-0.25
float gFilmIntensity = 0;
float3 sSkyColorTop = float3(255,0,0);
float3 sSkyColorBott = float3(0,255,255);
float sSkyLightIntensity = 0;

texture sReflectionTexture;
texture sRandomTexture;
texture sFringeTexture;


#include "mta-helper.fx"


sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler3D RandomSampler = sampler_state
{
    Texture = (sRandomTexture); 
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = POINT;
    MIPMAPLODBIAS = 0.000000;
};

sampler2D ReflectionSampler = sampler_state
{
    Texture = (sReflectionTexture);	
    AddressU = Mirror;
    AddressV = Mirror;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

sampler2D gFringeMapSampler = sampler_state 
{
    Texture = (sFringeTexture);
    MinFilter = Linear;
    MipFilter = Linear;
    MagFilter = Linear;
    AddressU  = Clamp;
    AddressV  = Clamp;
};

struct VSInput
{
    float4 Position : POSITION; 
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 View : TEXCOORD1;
};

struct PSInput
{
    float4 Position : POSITION;
    float4 Diffuse : COLOR0;
    float4 Specular : COLOR1;   
    float3 TexCoord : TEXCOORD0;
    float3 Tangent : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
    float3 View : TEXCOORD4;
    float3 SparkleTex : TEXCOORD5;
    float3 FilmDepth : TEXCOORD6;
    float3 ViewNormal : TEXCOORD7;
};


float calc_view_depth(float NDotV,float Thickness)
{
    return (Thickness / NDotV);
}

PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
    float4 worldPosition = mul ( VS.Position, gWorld );
    float4 viewPosition  = mul ( worldPosition, gView );
    PS.Position  = mul ( viewPosition, gProjection );
 
    PS.View =  gCameraPosition - worldPosition;
	
    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal =normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );

    // Transfer some stuff
    PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );
	
    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 4.0/sSparkleSize;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 4.0/sSparkleSize;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 4.0/sSparkleSize; 
	
    // Reflection lookup coords to pixel shader
    float4 worldPos = mul( float4(VS.Position.xyz,1) , gWorld );	
    float4 viewPos = mul( worldPos , gView ); 
    float4 projPos = mul( viewPos, gProjection);
	projPos.x *= uvMul.x; 
    projPos.y *= uvMul.y;	
    float projectedX = (0.5 * ( projPos.w + projPos.x )) + uvMov.x;
    float projectedY = (0.5 * ( projPos.w + projPos.y )) + uvMov.y;
    PS.TexCoord = float3(projectedX, projectedY, projPos.w );	

    // Set information for the refraction
    PS.ViewNormal = normalize( mul(PS.Normal, (float3x3)gView ));
	
    // compute the view depth for the thin film
    float3 Nn = mul(VS.Normal,gWorldInverseTranspose).xyz;	
    float3 Vn = normalize(PS.View);
    float vdn = dot(Vn,Nn);
    float viewdepth = calc_view_depth(vdn,gFilmDepth.x);
    PS.FilmDepth.xy = viewdepth.xx;	
	
    // Calc lighting
    PS.Diffuse = MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );

    // Normal Z vector for sky light 
    float skyTopmask = pow(PS.Normal.z,5);
    PS.Specular.rgb = (skyTopmask * sSkyColorTop + saturate(PS.Normal.z-skyTopmask)* sSkyColorBott );
    PS.Specular.rgb *= gGlobalAmbient.xyz;
    PS.Specular.a = pow(PS.Normal.z,sNormZ);
    PS.FilmDepth.z = saturate(PS.Specular.a);
    if (gCameraDirection.z < minZviewAngleFade) PS.Specular.a = PS.FilmDepth.z * (1 - saturate((-1/minZviewAngleFade ) * (minZviewAngleFade - gCameraDirection.z)));
    return PS;
}

//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    //reflection variable here

    // Some settings for something or another
    float microflakePerturbation = 1.00;

    // Micro-flakes normal map is a high frequency normalized
    // vector noise map which is repeated across the surface.

    float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;

    // Don't forget to bias and scale to shift color into [-1.0, 1.0] range:
    vFlakesNormal = 2 * vFlakesNormal - 1.0;

    // To compute the surface normal for the second layer of micro-flakes, which
    // is shifted with respect to the first layer of micro-flakes, we use this formula:
    // Np2 = ( c * Np + d * N ) / || c * Np + d * N || where c == d
    float3 vNp2 = microflakePerturbation * (( vFlakesNormal + 1.0)/2) ;

    // The view vector (which is currently in world space) needs to be normalized.
    // This vector is normalized in the pixel shader to ensure higher precision of
    // the resulting view vector. For this highly detailed visual effect normalizing
    // the view vector in the vertex shader and simply interpolating it is insufficient
    // and produces artifacts.

    float3 vView = normalize(PS.View);
    float3 vNormal = normalize(PS.Normal);
    // Transform the surface normal into world space (in order to compute reflection
    // vector to perform environment map look-up):
    float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent,PS.Binormal, PS.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, vNormal ));
    float fNdotV = saturate(dot( vNormalWorld, vView ));

    // reflection lookup coords
    float2 vReflection = float2(PS.TexCoord.x,PS.TexCoord.y)/PS.TexCoord.z;
	vReflection += PS.ViewNormal.rg * float2(sNorFacXY, sNorFacZ);
	
    // Hack in some bumpyness
    vReflection.x += vNp2.x * (0.1 * bumpSize) - (0.1 * bumpSize);
    vReflection.y += vNp2.y * (0.05 * bumpSize) - (0.05 * bumpSize);
	
    float4 envMap = tex2D( ReflectionSampler, vReflection );
    float lum = (envMap.r + envMap.g + envMap.b)/3;
    float adj = saturate( lum - sCutoff );
    adj = adj / (1.01 - sCutoff);
    envMap += sAdd+1.0; 
    envMap = (envMap * adj);
    envMap = pow(envMap, sPower+2); 
    envMap *= sMul;

    // Sample fringe map:
    float3 fringeCol = (float3)tex2D(gFringeMapSampler, PS.FilmDepth.xy)* PS.FilmDepth.z;

    // Brighten the environment map sampling result:
    envMap.rgb *= brightnessFactor;	 
	
    envMap.a =1;	
    float4 first = float4((envMap.rgb+ 0.5 * PS.Specular.rgb * sSkyLightIntensity),PS.Specular.a);
    float4 second = float4(1.2 * (PS.Specular.rgb),1.2 * sSkyLightIntensity * PS.FilmDepth.z);

    envMap = lerp(first,second,1 - PS.Specular.a);
    float fEnvContribution = 1.1 - 1 *fNdotV; 
    float4 finalColor = ((envMap)*(fEnvContribution));
    float4 Color = finalColor;
    Color.rgba += float4(fringeCol,gFilmIntensity* PS.FilmDepth.z) * gFilmIntensity;
    Color.a *= transFactor;
    Color.a *= PS.Diffuse.a;
    return saturate(Color);

}


technique car_reflect_paint_v3
{
    pass P0
    {
        DepthBias = -0.0003;
        AlphaRef = 1;
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
