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
        (1, "a cat with glasses"),
        (1, "a cat with sharp eyes"), # a cat with wise eyes
        (2, "a cat with a pencil"),
        (3, "a cat with a pencil"),
        (2, "a cat with an eraser"),
        (3, "a cat with an eraser"),
        (2, "a cat with a book"),
        (3, "a cat with a book"),
        (2, "a cat with a personal computer in his hand"),
        (3, "a cat with a personal computer in his hand"),
        (4, "a cat in school uniform")
    ],
    "reserch": [
        (0, "a cat with an academic cap"),
        (1, "a cat with doctor beard"),
        (1, "a cat with glasses"),
        (1, "a cat with sharp eyes"),
        (2, "a cat with a book"),
        (3, "a cat with a book"),
        (2, "a cat with a personal computer in his hand"),
        (3, "a cat with a personal computer in his hand"),
        (2, "a cat with a conical flask in his hand"),
        (3, "a cat with a conical flask in his hand"),
        (4, "a cat in doctor's white robe")
    ],
    "music": {
        "guitar": [
            (0, "a cat with mohawk"),
            (1, "a cat with sun glasses"),
            (2, "a cat with a guitar"),
            (3, "a cat with a guitar"),
            (2, "a cat with musical note"), # musical symbol
            (3, "a cat with musical note"),
            (4, "a cat in rock costume") # pianist's suit
        ],
        "piano": [
            #(2, "a cat with a piano"),
            #(3, "a cat with a piano"),
            (2, "a cat with musical note"), # musical symbol
            (3, "a cat with musical note"),
            (4, "a cat in tuxedo") # pianist's suit
        ],
        "other music": [
            (2, "a cat with musical note"), # musical symbol
            (3, "a cat with musical note"),
        ]
    },
    "exercise": {
        "soccer": [
            (2, "a cat with soccer ball"),
            (3, "a cat with soccer ball"),
            (4, "a cat in soccer uniform")
        ],
        "baseball": [
            (0, "a cat with base ball cap"),
            #(2, "a cat with baseball globe"),
            #(3, "a cat with baseball globe"),
            (2, "a cat with baseball ball"),
            (3, "a cat with baseball ball"),
            (2, "a cat with baseball bat"),
            (3, "a cat with baseball bat"),
            (4, "a cat in baseball uniform")
        ],
        "volleyball": [
            (2, "a cat with volleyball ball"),
            (3, "a cat with volleyball ball"),
            (4, "a cat in volleyball uniform"),
        ],
        "basketball": [
            (2, "a cat with basketball ball"),
            (3, "a cat with basketball ball"),
            (4, "a cat in basketball uniform"),
        ],
        "swimming": [
            (1, "a cat wearing swimming goggles"),
            (2, "a cat with surfboard"),
            (3, "a cat with surfboard"),
            (4, "a cat in swimsuit")
        ],
        "bicycle": [
            (2, "a cat with bicycle"),
            (3, "a cat with bicycle"),
            (4, "a cat in cycling suit")
        ],
        "other exercise": [
            (1, "a cat with strong look"),
            (2, "a cat with dumbbell"),
            (3, "a cat with dumbbell"),
            (4, "a muscular cat"),
            (4, "a cat in tank top")
        ]
    },
    "game": [
        (0, "a cat with mario's cap"),
        (2, "a cat with game console"),
        (3, "a cat with game console"),
        (4, "a cat in mario's overall")
    ],
    "housework": {
        "cooking": [
            #(0, "a cat in a triangle bandage"),
            (2, "a cat with ladle"),
            (3, "a cat with ladle"),
            (2, "a cat with kitchen knife"),
            (3, "a cat with kitchen knife"),
            (2, "a cat with fry pan"),
            (3, "a cat with fry pan"),
            (2, "a cat with fish"),
            (3, "a cat with fish"),
            (4, "a cat in cooking apron")
        ],
        "cleaning": [
            #(0, "a cat in a triangle bandage"),
            (1, "a cat wearing mask"),
            (2, "a cat with vacuum cleaner"),
            (3, "a cat with vacuum cleaner"),
            (2, "a cat with dustpan"),
            (3, "a cat with dustpan"),
            (2, "a cat with broom"),
            (3, "a cat with broom"),
        ],

        """"laundry": [
            (2, "a cat with tarai"),
            (3, "a cat with tarai"),
            (2, "a cat with washboard"),
            (3, "a cat with washboard"),
        ],"""

        "gardening": [
            (0, "a cat with straw hat"),
            (2, "a cat with shovel"),
            (3, "a cat with shovel"),
            (2, "a cat with vegetable"),
            (3, "a cat with vegetable"),
            (4, "a cat with rubber boots")
        ],
        "other housework": [
            (1, "a smile cat"),
            (4, "a cat in apron")
        ]
    },
    "labor": {
        "desk work": [
            (1, "a cat with glasses"),
            (2, "a cat with a personal computer in his hand"),
            (3, "a cat with a personal computer in his hand"),
            (4, "a cat in business suit")
        ],
        "physical work": [
            (0, "a cat with construction helmet"),
            (4, "a cat in overall") # work clothes
        ]
    },
    "job hunting": [
        (1, "a cat with sharp eyes"),
        (4, "a cat in recruit suit"),
        (4, "a cat with the tie")
    ],
    "lifestyle": {
        "sleep": [
            (0, "a cat with nightcap"),
            (1, "a healthy-looking cat"),
            (1, "a cat with sharp eyes"),
            (2, "a cat with alarm clock"),
            (3, "a cat with alarm clock"),
            (2, "a cat with pillow"),
            (3, "a cat with pillow"),
        ],
        "meal": [
            (1, "a healthy-looking cat"),
            (2, "a cat with fork"),
            (3, "a cat with fork"),
            (2, "a cat with spoon"),
            (3, "a cat with spoon"),
            (2, "a cat with chopsticks"),
            (3, "a cat with chopsticks"),
            (2, "a cat with rice bowl"), #cuisine
            (3, "a cat with rice bowl"),
        ],
        "other lifestyle": [
            (1, "a healthy-looking cat"),
            (2, "a cat giving a thumbs up"),
            (3, "a cat giving a thumbs up"),
        ]
    },
    "other": [
        (0, "a cat with a hat"),
        (1, "a cat with strong look"),
        (1, "a cat with cute eyes"),
        (4, "a cat with strong look"),
        (2, "a cat giving a thumbs up"),
        (3, "a cat giving a thumbs up"),
        (4, "a cat in cute clothes")
    ]
}
