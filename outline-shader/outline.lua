local outline = {}

outline.type = {
	OUTLINE_STENCIL = 1,
	OUTLINE_INVERTED_HULL = 2
}


local draw_outline      = false
local outline_color     = vmath.vector4(1.0, 0.0, 0.0, 1.0)
local outline_thickness = vmath.vector4(0.5)
local outline_type      = 1
local outline_predicate = "model"

---@param thickness number
---@param color vector4
---@param type integer
function outline.set(thickness, color, type)
	outline_color = color
	outline_thickness = vmath.vector4(thickness)
	outline_type = type
end

---@param toggle boolean
function outline.draw(toggle)
	draw_outline = toggle
end

---@param tag string
function outline.set_tag(tag)
	outline_predicate = tag
end

function outline.init(self)
	self.predicates['outline']   = render.predicate({ outline_predicate })
	self.outline_constant_buffer = render.constant_buffer()
end

function outline.update(self, predicates, frustum)
	self.outline_constant_buffer.outline_color = outline_color
	self.outline_constant_buffer.outline_width = outline_thickness

	if draw_outline then
		if outline_type == outline.type.OUTLINE_STENCIL then
			-- First pass: Render the object to the stencil buffer
			render.set_stencil_mask(0xFF)

			render.set_stencil_func(graphics.COMPARE_FUNC_ALWAYS, 1, 0xFF)
			render.set_stencil_op(graphics.STENCIL_OP_REPLACE, graphics.STENCIL_OP_REPLACE, graphics.STENCIL_OP_REPLACE)
			render.enable_state(graphics.STATE_STENCIL_TEST)
			render.draw(predicates.outline, { frustum = frustum.frustum })

			-- Second pass: Render the scaled-up outline where stencil buffer is 1
			render.set_stencil_func(graphics.COMPARE_FUNC_NOTEQUAL, 1, 0xFF)
			render.set_stencil_op(graphics.STENCIL_OP_KEEP, graphics.STENCIL_OP_KEEP, graphics.STENCIL_OP_KEEP)
			render.enable_material("outline")
			render.draw(predicates.outline, { frustum = frustum.frustum, constants = self.outline_constant_buffer })
			render.disable_material()

			-- set defaults
			render.set_stencil_func(graphics.COMPARE_FUNC_ALWAYS, 0, 0xFF)
			render.disable_state(graphics.STATE_STENCIL_TEST)
		elseif outline_type == outline.type.OUTLINE_INVERTED_HULL then
			render.enable_state(graphics.STATE_DEPTH_TEST)
			render.enable_state(graphics.STATE_CULL_FACE)

			render.set_cull_face(graphics.FACE_TYPE_BACK)
			render.draw(predicates.outline, { frustum = frustum.frustum })

			render.set_cull_face(graphics.FACE_TYPE_FRONT)
			render.enable_material("outline")
			render.draw(predicates.outline, { frustum = frustum.frustum, constants = self.outline_constant_buffer })
			render.disable_material()

			render.set_cull_face(graphics.FACE_TYPE_BACK) -- revert back the default mode, i.e. FACE_BACK
			render.disable_state(graphics.STATE_CULL_FACE)
		end
	else
		-- render predicate for default 3D material
		--
		render.enable_state(graphics.STATE_CULL_FACE)
		render.draw(predicates.outline, frustum)
		render.disable_state(graphics.STATE_CULL_FACE)
	end
end

return outline
