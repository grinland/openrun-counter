type("counter",
     fields=[
         field("name", STRING),
         field("value", INT),
     ],
     indexes=[
         index(["name"], unique=True)
     ])
