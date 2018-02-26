---
layout: post
title:  "Coding syntax"
date:   2018-02-22
tags: [julia, python]
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


function generate_mesh_fdt(nx::Int, ny::Int)
    pts  =  Point[ 
                  Point([0.0, 0.0], 4.0),
                  Point([2.5, 0.0], 1.0),
                  Point([2.5, 3.0], 4.0),
                  Point([0.0, 3.0], 7.0),]
    # note: the more element, the more exact load, in the tendency to increase the load
    # because we are using the strain displacement, to get the sum of load, the adequate number of element is necessary
    surf     = Surface{Quad4}(pts..., nx, ny)
    nodes    = numbering!(surf)
    elements = get_elements(surf)
    bottom   = get_elements(surf[1:end,1])
    top      = get_elements(surf[1:end,end]) 
    left     = get_elements(surf[1,1:end])
    right    = get_elements(surf[end,1:end])
    top_load = []
    for i = 1:nx
        y = hcat(top[i]["geometry"][1]...)[1,:][2]
        if (y<= 0.5 )
            push!(top_load, top[i])
        end
    end
    plot_mesh(elements, top_load)
    return nodes, elements, bottom, top_load, left, right
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

