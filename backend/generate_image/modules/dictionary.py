#不要かな
CATEGORY_LIST = [
    "study",
    "hobby",
    "housework",
    "labor",
    "exercise",
    "job hunting",
    "lifestyle",
    "other"
] 

"""
頭: 0, 顔: 1, 右手: 2, 左手: 3, 胴体: 4
"""

TRANSFORM_PROMPT = {
    "study": [
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ],
    "hobby": [

    
    ],
    "housework": [

    ],
    "labor": [
        
    ],
    "exercise": {
        "soccer": [
            (2, "a cat with soccer ball"),
            (3, "a cat with soccer ball"),
            (4, "a cat with soccer uniform")
        ],
        "base ball": [
            (0, "a cat with base ball cap"),
        ],
        "volley-ball": [
            
        ],
        "swimming": [
            
        ],
    },
    "job hunting": [

    ],
    "lifestyle": [

    ],
    "other": [

    ]
}
