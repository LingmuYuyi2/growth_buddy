from django.http import HttpResponse
from django.urls import path
from .views import MyView, SampleImageView

def hello(request):
    return HttpResponse("Hello")

urlpatterns = [
    path('generate_image/', MyView.as_view()),
    path('healthz/', hello),
    path('sample_image/', SampleImageView.as_view())
]
