local Color = require 'UnityEngine.Color'
local GameObject = UnityEngine.GameObject           
local ParticleSystem = UnityEngine.ParticleSystem                        
local go = GameObject('go')
go:AddComponent(typeof(ParticleSystem))
local node = go.transform
node.position = Vector3.one
node.gameobject = GameObject('go_1')
print('gameObject is: '..tostring(go))                 
GameObject.Destroy(go, 2)                  
print('delay destroy gameobject is: '..go.name)     