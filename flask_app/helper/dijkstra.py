# class Vertex:
#     #顶点类
#     def __init__(self,vid,outList):
#         self.vid = vid#出边
#         self.outList = outList#出边指向的顶点id的列表，也可以理解为邻接表
#         self.know = False#默认为假
#         self.dist = float('inf')#s到该点的距离,默认为无穷大
#         self.prev = 0#上一个顶点的id，默认为0
#     def __eq__(self, other):
#         if isinstance(other, self.__class__):
#             return self.vid == other.vid
#         else:
#             return False
#     def __hash__(self):
#         return hash(self.vid)

# #创建顶点对象
# v1=Vertex(1,[2,4])
# v2=Vertex(2,[4,5])
# v3=Vertex(3,[1,6])
# v4=Vertex(4,[3,5,6,7])
# v5=Vertex(5,[7])
# v6=Vertex(6,[])
# v7=Vertex(7,[6])
# #存储边的权值
# edges = dict()
# def add_edge(front,back,value):
#     edges[(front,back)]=value
# add_edge(1,2,2)
# add_edge(1,4,1)
# add_edge(3,1,4)
# add_edge(4,3,2)
# add_edge(2,4,3)
# add_edge(2,5,10)
# add_edge(4,5,2)
# add_edge(3,6,5)
# add_edge(4,6,8)
# add_edge(4,7,4)
# add_edge(7,6,1)
# add_edge(5,7,6)
# #创建一个长度为8的数组，来存储顶点，0索引元素不存
# vlist = [False,v1,v2,v3,v4,v5,v6,v7]
# #使用set代替优先队列，选择set主要是因为set有方便的remove方法
# vset = set([v1,v2,v3,v4,v5,v6,v7])

# def get_unknown_min():#此函数则代替优先队列的出队操作
#     the_min = 0
#     the_index = 0
#     j = 0
#     for i in range(1,len(vlist)):
#         if(vlist[i].know is True):
#             continue
#         else:
#             if(j==0):
#                 the_min = vlist[i].dist
#                 the_index = i
#             else:
#                 if(vlist[i].dist < the_min):
#                     the_min = vlist[i].dist
#                     the_index = i                    
#             j += 1
#     #此时已经找到了未知的最小的元素是谁
#     vset.remove(vlist[the_index])#相当于执行出队操作
#     return vlist[the_index]

# def main():
#     #将v1设为顶点
#     v1.dist = 0

#     while(len(vset)!=0):
#         v = get_unknown_min()
#         print(v.vid,v.dist,v.outList)
#         v.know = True
#         for w in v.outList:#w为索引
#             if(vlist[w].know is True):
#                 continue
#             if(vlist[w].dist == float('inf')):
#                 vlist[w].dist = v.dist + edges[(v.vid,w)]
#                 vlist[w].prev = v.vid
#             else:
#                 if((v.dist + edges[(v.vid,w)])<vlist[w].dist):
#                     vlist[w].dist = v.dist + edges[(v.vid,w)]
#                     vlist[w].prev = v.vid
#                 else:#原路径长更小，没有必要更新
#                     pass
# main()
# print('v1.prev:',v1.prev,'v1.dist',v1.dist)
# print('v2.prev:',v2.prev,'v2.dist',v2.dist)
# print('v3.prev:',v3.prev,'v3.dist',v3.dist)
# print('v4.prev:',v4.prev,'v4.dist',v4.dist)
# print('v5.prev:',v5.prev,'v5.dist',v5.dist)
# print('v6.prev:',v6.prev,'v6.dist',v6.dist)
# print('v7.prev:',v7.prev,'v7.dist',v7.dist)


from collections import defaultdict
from heapq import *

def run(edges, f, t):
    edges_on_nodes = defaultdict(list)
    for each in edges:
        edges_on_nodes[each['node_from_id']].append((each['distance'],each['node_to_id']))
        edges_on_nodes[each['node_to_id']].append((each['distance'],each['node_from_id']))
    # print(g)
    q, seen, mins = [(0,f,())], set(), {f: 0}
    while q:
        (cost,v1,path) = heappop(q)
        # print((cost,v1,path))
        if v1 not in seen:
            seen.add(v1)
            path = (v1, path)
            if v1 == t: return (cost, path)
            for c, v2 in edges_on_nodes.get(v1, ()):
                if v2 in seen: continue
                prev = mins.get(v2, None)
                next = cost + c
                if prev is None or next < prev:
                    mins[v2] = next
                    heappush(q, (next, v2, path))

    return float("inf")

if __name__ == "__main__":
    edges = [
        {
            "id": 1,
            "node_from_id": 1,
            "node_to_id": 2,
            "distance": 1,
            "direction_2d": 0,
            "level_from": 2,
            "level_to": 2
        },
        {
            "id": 2,
            "node_from_id": 2,
            "node_to_id": 3,
            "distance": 142,
            "direction_2d": 45
        },
        {
            "id": 3,
            "node_from_id": 3,
            "node_to_id": 4,
            "distance": 101,
            "direction_2d": 90
        },
        {
            "id": 4,
            "node_from_id": 2,
            "node_to_id": 4,
            "distance": 1,
            "direction_2d": 0,
            "level_from": 2,
            "level_to": 1
        }
    ]

    print ("=== Dijkstra ===")
    print (edges)
    print ("1-> 4")
    print (run(edges, 1, 4))
    print ("1 -> 3:")
    print (run(edges, 1, 3))