from django.shortcuts import render
import requests
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
import os
import dotenv
import openai
import replicate
import base64

dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
dotenv.load_dotenv(dotenv_path)
API_KEY_GPT = os.environ.get("API_KEY_GPT")
REPLICATE_API_TOKEN = os.environ.get("REPLICATE_API_TOKEN")

class MyView(APIView):
    def post(self, request, *args, **kwargs):
        openai.api_key = API_KEY_GPT
        
        # リクエストデータを抽出
        texts = request.data.get('texts')
        image = request.data.get('image')
        
        messages = [
            {"role": "system", "content": "以下のテキスト群のトピックを英単語5つコンマ区切りで生成してください。"},
            {"role": "user", "content": "\n".join(texts)}
        ]

        # GPT APIへのリクエスト
        gpt_response = openai.ChatCompletion.create(\
                model="gpt-3.5-turbo",
                messages=messages,
                temperature=0.3,
            )
        
        topics = gpt_response['choices'][0]['message']['content']
        
        image = open(image, "rb")
        
        input = {
            "image": image,
            "prompt": topics,
        }
        
        # img2imgAPIへのリクエスト
        custom_api_response = replicate.run(
            "stability-ai/stable-diffusion-img2img:15a3689ee13b0d2616e98820eca31d4c3abcd36672df6afce5cb6feb1d66087d",
            input= input
            )
        
        response = requests.get(custom_api_response[0])
        image_data = response.content
        # 画像データをBase64形式にエンコードする
        image_data_base64 = base64.b64encode(image_data).decode()
        
        content_type = response.headers.get('content-type')
        
        with open('output.jpg', 'wb') as out_file:
            out_file.write(image_data)

        # レスポンスを返す
        return Response({'image': image_data_base64}, status=status.HTTP_200_OK, content_type=content_type)