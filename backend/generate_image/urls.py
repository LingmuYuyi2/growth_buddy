from django.http import HttpResponse
from django.urls import path
from .views import MyView

def hello(request):
    return HttpResponse("Hello")

urlpatterns = [
    path('generate_image/', MyView.as_view()),
    path('healthz/', hello),
]
