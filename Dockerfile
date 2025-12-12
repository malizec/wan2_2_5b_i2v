# clean base image containing only comfyui, comfy-cli and comfyui-manager
FROM runpod/worker-comfyui:5.6.0-base-cuda12.8.1

# install custom nodes into comfyui
# (no custom registry-verified nodes in workflow)
RUN comfy node install comfyui-easy-use
RUN git clone https://github.com/tsogzark/ComfyUI-load-image-from-url.git /comfyui/custom_nodes/ComfyUI-load-image-from-url

# download models into comfyui
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors --relative-path models/diffusion_models --filename wan2.2_ti2v_5B_fp16.safetensors

RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors --relative-path models/clip --filename umt5_xxl_fp8_e4m3fn_scaled.safetensors

RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan2.2_vae.safetensors --relative-path models/vae --filename wan2.2_vae.safetensors

RUN pwd
RUN ls -lah /
RUN ls -lah /runpod-volume/
RUN ls -lah /runpod-volume/custom_nodes
RUN ls -lah /runpod-volume/models/diffusion_models
RUN ls -lah /comfyui/
# copy all input data (like images or videos) into comfyui (uncomment and adjust if needed)
# COPY input/ /comfyui/input/
