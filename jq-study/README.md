### jqの使い方

`$ cat sample-api.json`
```
{
    "weather201609":
  [
	{
	    "date":"2016-09-25",
            "weather":"Sunny"
	},
        {
            "date":"2016-09-26",
            "weather":"Cloudiness"
        },
        {
            "date":"2016-09-27",
            "weather":"rain"
        }
  ]
}
```

`$ cat sample-api.json | jq '.weather201609'`
```
[
  {
    "date": "2016-09-25",
    "weather": "Sunny"
  },
  {
    "date": "2016-09-26",
    "weather": "Cloudiness"
  },
  {
    "date": "2016-09-27",
    "weather": "rain"
  }
]
```

`$ cat sample-api.json | jq '.weather201609[]'`
```
{
  "date": "2016-09-25",
  "weather": "Sunny"
}
{
  "date": "2016-09-26",
  "weather": "Cloudiness"
}
{
  "date": "2016-09-27",
  "weather": "rain"
}
```

`$ cat sample-api.json | jq '.weather201609[] | .date'`
```
"2016-09-25"
"2016-09-26"
"2016-09-27"
```
