from locust import HttpLocust, TaskSet, task
from requests_toolbelt.multipart.encoder import MultipartEncoder
import os
import json
import random

class UserBehavior(TaskSet):
    def on_start(self):
        """ on_start is called when a Locust start before any task is scheduled """

    def create_some_owners(self):
        owners = []
        for i in range(0,random.randint(5, 256)):
            owners.append((str(i), os.urandom(random.randint(12, 46))))
        multipart_data = MultipartEncoder(fields=owners)
        return self.client.post("/api/timedb/meta/owners", data=multipart_data, headers={'Content-Type': multipart_data.content_type})

    @task(1)
    def create(self):
        self.create_some_owners()

class WebsiteUser(HttpLocust):
    task_set = UserBehavior
    min_wait = 10
    max_wait = 5000
