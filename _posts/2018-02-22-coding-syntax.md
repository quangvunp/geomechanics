---
layout: post
title:  "Coding syntax"
date:   2018-02-22
tags:  [jekyll]
---



This is master branch
A Python example:

{% highlight python %}
def hello()
  print("Hello World!")
{% endhighlight %}



A Julia example:

{% highlight julia%}
function hello()
  print("Hello World!")
end

type CamClay
  a::Int
  b::Vector{Int}
end

"""
Elastic 
\alpha + \beta = 1
"""
function De(model::CamClay, x::Int)
  return ones(1,4)
end 
{% endhighlight %}

And this is a HTML example, with a linenumber:
{% highlight html %}

<html>
  <a href="example.com">Example</a>
</html>
{% endhighlight %}

