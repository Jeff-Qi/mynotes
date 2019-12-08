# a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# b = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
# c = {1, 2, 3, 4, 5, 6, 7, 10, 10,8,9}
# print(c[1])
#
# print(a, b, c, sep=' ')
# for i in c:
#     print(i, end=' ')
# a={}
# getattr().update()
# setattr()
# print("1" = 1)

# import itertools
# a = [{'a': '1'}, {'a': '1', 'A': '10'}, {'a': '2', 'B': '20'}]

# import operator
# pirnt(operator.itemgetter('a'))
# [(key, list(group)) for key, group in list(itertools.groupby(a, operator.itemgetter('a')))]
# a = [1,2,3]
# b = [1,2]
# c = set(a) - set(b)
# print(c)

# import collections
# def add_animal(s, a, f):
#     s[f].add(a)
# s = collections.defaultdict(set)
# add_animal(s, 'xixi', 'haha')
# print(s)

# import dis
# def a():
#     print('hello word')
# dis.dis(a)

# import bisect
# a = ('a', 'e', 'c', 'd')
# def concat():
#     for i in a:
#         hah = a[0] + i
#         print(hah)
# concat()
# a = sorted(a)
# print(bisect.bisect(a, 'd'))
# print(bisect.bisect(a, 'b'))
# print(bisect.bisect(a, 'f'))
# bisect.insort(a, 'f')
# print(a)
#
# import collections
# foobar = collections.namedtuple('a', ['x', 'y', 'z'])
# print(foobar(1, 2, 3).y)
# print(type(foobar))
