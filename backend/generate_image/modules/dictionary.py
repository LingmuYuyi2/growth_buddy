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
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ],
    "housework": [
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ],
    "labor": [
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ],
    "exercise": [
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ],
    "job hunting": [
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ],
    "lifestyle": [
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ],
    "other": [
        (0, "a cat with an academic cap"),
        (2, "a cat with a pencil")
    ]
}
