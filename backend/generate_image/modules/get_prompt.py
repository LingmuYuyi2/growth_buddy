import openai
from .dictionary import *
from typing import List
import dotenv
import os
import random


dotenv_path = os.path.join(os.path.dirname(__file__), '.env')
dotenv.load_dotenv(dotenv_path)
OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY")

def get_topic(text: str) -> str:
    openai.api_key = OPENAI_API_KEY
    
    dictionary = TRANSFORM_PROMPT
    
    while not isinstance(dictionary, list):
        messages = [
            {"role": "system", "content": "以下のテキスト群には、次の中のどのトピックが最もふさわしいか1つ答えてください。\n" + "\n".join(dictionary.keys())},
            {"role": "user", "content": text}
        ]

        # GPT APIへのリクエスト
        gpt_response = openai.ChatCompletion.create(\
                model="gpt-3.5-turbo",
                messages=messages,
                temperature=0.8,
            )
        
        topic = gpt_response['choices'][0]['message']['content']
        
        dictionary = dictionary[topic]
    
    return topic 
   

def choice_from_dictionary(topic: str, position_before: str):
    if position_before:
        position_before = int(position_before)
    
    prompt_list = TRANSFORM_PROMPT[topic]
    
    prompt_diff_from_bef_pos = [pos_prompt for pos_prompt in prompt_list if pos_prompt[0] != position_before]
    
    
    return random.choice(prompt_diff_from_bef_pos)

def choice_text(text_list: List[str], endurance_list: List[int]) -> str:
    l = []
    for i, endurance in enumerate(endurance_list):
        l.extend([i] * int(float(endurance)))
    
    choice = random.choice(l)
    
    return text_list[choice]

def get_position_and_prompt(text_list: List[str], endurance_list: List[int], position_before: int):
    text = choice_text(text_list, endurance_list)
    topic = get_topic(text)
    return choice_from_dictionary(topic, position_before)
    
    
    
if __name__ == "__main__":
    texts = ["ギターの練習をした。", "研究を進めた。教授とミーティングをした。","朝早起きして、朝ごはんを食べた。"]
    
    text = choice_text(texts, [1,2,5])
    
    topic = get_topic(text)
    
    print(topic)
    
    topic = "study"
    
    position, prompt = choice_from_dictionary(topic, "2")
    
    print(position)
    print(prompt)