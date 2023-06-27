from django.urls import path
from .views import MyView

urlpatterns = [
    path('generate_image/', MyView.as_view()),
]
