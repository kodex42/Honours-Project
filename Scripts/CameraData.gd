extends Resource

class_name CameraData

# Relative to the target
export(Vector3) var anchor_offset
# Relative to the target and anchor offset
export(Vector3) var target_offset
# Relative to target + anchor_offser = target_offset
export(Vector3) var rotation
# Relative to everything else
export(Vector3) var look_target
export(Vector2) var pitch_limit
