FROM runpod/worker-comfyui:5.6.0-base-cuda12.8.1

# install nodes
RUN comfy node install comfyui-easy-use
RUN comfy node install comfy-mtb

# install deps
RUN pip install -r /comfyui/custom_nodes/comfyui-easy-use/requirements.txt
RUN pip install -r /comfyui/custom_nodes/comfy-mtb/requirements.txt

# preload script
RUN echo '\
import sys\n\
sys.path.append("/comfyui")\n\
sys.path.append("/comfyui/custom_nodes")\n\
import nodes\n\
nodes.init_extra_nodes()\
' > /comfyui/preload_custom_nodes.py

# models
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_ti2v_5B_fp16.safetensors --relative-path models/diffusion_models --filename wan2.2_ti2v_5B_fp16.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors --relative-path models/clip --filename umt5_xxl_fp8_e4m3fn_scaled.safetensors
RUN comfy model download --url https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan2.2_vae.safetensors --relative-path models/vae --filename wan2.2_vae.safetensors

CMD ["bash", "-c", "python /comfyui/preload_custom_nodes.py && python /comfyui/main.py --listen 0.0.0.0 --port 8188 --disable-auto-launch"]
