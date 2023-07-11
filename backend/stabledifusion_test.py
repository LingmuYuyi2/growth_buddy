from PIL import Image
# 入力画像の読み込み（適宜自分のパスに書き換える）
init_img = Image.open("cat.jpeg")
import torch
from torch import autocast
from diffusers import StableDiffusionImg2ImgPipeline
model_id = "CompVis/stable-diffusion-v1-4"
device = "cpu"
# パイプラインの作成
pipe = StableDiffusionImg2ImgPipeline.from_pretrained(model_id, revision="fp16", torch_dtype=torch.float32)
pipe = pipe.to(device)
# プロンプト
prompt = "犬にしてください"
# パイプラインの実行
generator = torch.Generator(device).manual_seed(42) # 再現できるようにseedを設定
with torch.autocast("cpu"):
    image = pipe(prompt, image=init_img, guidance_scale=7.5, strength=0.75, generator=generator).images[0]
# 変換した画像の保存
image.save("egg2dog.png")