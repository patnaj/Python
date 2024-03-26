#%%
import package_example.test as test
dir(test)
print(test.the_answer)
print(test.add(1,2))
test.system("ls ../")


import package_example.obj as obj
dir(obj)
p = obj.Pet("kot")
dir(p)
print(p.getName())
# %%
