#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(location = 0) in vec3 inPosition;
layout(location = 1) in vec3 inNormal;
layout(location = 2) in vec2 inUV;
layout(location = 3) in vec3 inT;
layout(location = 4) in vec3 inB;

layout(location = 2) out vec2 texCoords;
layout(location = 3) out vec3 fragNormal;
layout(location = 4) out vec3 WorldPos;
layout(location = 7) out vec3 fragTangent;
layout(location = 8) out vec3 fragBiTangent;
layout(location = 9) out mat3 TBN;

layout(	push_constant ) uniform VertexMatricesBuffer
{
	mat4 model;
} ubo;

layout(set = 0,binding = 2) uniform ProjVertexBuffer{
	mat4 view;
	mat4 proj;
} pv;

void main(){
	gl_Position = pv.proj * pv.view * ubo.model * vec4(vec3(inPosition.x, inPosition.y, inPosition.z), 1.0);
	gl_Position.y = -gl_Position.y;

	WorldPos = vec3(ubo.model * vec4(inPosition, 1.0));
	texCoords = inUV;
	fragNormal = mat3(transpose(inverse(ubo.model))) * inNormal;
	fragTangent = mat3(transpose(inverse(ubo.model))) * inT;
	fragBiTangent = mat3(transpose(inverse(ubo.model))) * inB;

    //Gram-Schmidt process
    vec3 T = normalize(vec3(ubo.model * vec4(inT, 0.0)));
	//vec3 B = normalize(vec3(ubo.model * vec4(inB, 0.0)));
    vec3 N = normalize(vec3(ubo.model * vec4(inNormal, 0.0)));
    T = normalize(T - dot(T,N) * N);
    vec3 B = cross(N, T);

    TBN = mat3(T, B, N);
}
