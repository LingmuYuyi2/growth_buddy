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
from io import BytesIO

from .modules.get_prompt import get_position_and_prompt

dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
dotenv.load_dotenv(dotenv_path)
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")

class MyView(APIView):
    def post(self, request, *args, **kwargs):
        openai.api_key = OPENAI_API_KEY
        
        # リクエストデータを抽出
        info_list = request.data.get('info', [])
        content_list = [item.get('content', '') for item in info_list]
        effort_list = [item.get('effort', 0) for item in info_list]
        position_before = request.data.get('position')
        image_base64 = request.data.get('image')

        # base64形式の画像データをバイナリにデコード
        image_bytes = base64.b64decode(image_base64)
        image = BytesIO(image_bytes)
        
        position, prompt = get_position_and_prompt(content_list, effort_list, position_before)
        
        mask_path = os.path.dirname(__file__) + '/modules/figures/mask' + str(position) + ".png"
        
        with open(mask_path, 'rb') as mask_file:
            files = {
                'image': image,
                'mask': mask_file.read(),
            }
            
        data = {
            'prompt': prompt,
            'n': 1,
            'size': '1024x1024',
            "response_format": "b64_json"
        }

        # ヘッダーを作成
        headers = {
            'Authorization': 'Bearer ' + OPENAI_API_KEY
        }

        # POSTリクエストを作成
        dalle2_response = requests.post(
            'https://api.openai.com/v1/images/edits',
            headers=headers,
            files=files,
            data=data
        )
        
        image_data_base64 = dalle2_response.json()["data"][0]['b64_json']        
        
        content_type = dalle2_response.headers.get('content-type')

        # レスポンスを返す

        return Response({'image': image_data_base64, "changed_position": position}, status=status.HTTP_200_OK, content_type=content_type)

class SampleImageView(APIView):
    def post(self, request, *args, **kwargs):
        url = f"https://dog.ceo/api/breeds/image/random"

        response = requests.get(url)
        response_data = response.json()

        if response.status_code == 200 and response_data['status'] == 'success':
            image_url = response_data['message']
            image_response = requests.get(image_url)

            # Convert the image bytes to base64
            image_data_base64 = base64.b64encode(image_response.content).decode('utf-8')
            content_type = 'image/jpg'

            return Response({'image': image_data_base64}, status=status.HTTP_200_OK, content_type=content_type)
        else:
            return Response({'error': 'Could not retrieve image'}, status=status.HTTP_400_BAD_REQUEST)
