import api

redef class AppConfig
	# The default player, if any, that will be logged on a new session
	var debug_player: String is lazy do return value_or_default("app.debug.player", "")

	init do
		engine_map["nitc"] = new NitcEngine
	end
end

redef class Session
	# Was the session auto logged by `debug_player`?
	# Used to allow a real logout by not auto-login again and again.
	var auto_logged = false
end

redef class SessionRefresh
	redef fun all(req, res) do
		super
		if config.debug_player == "" then return

		var session = req.session
		if session == null then return
		if session.auto_logged then return
		var player = session.player
		if player == null then
			session.player = config.players.find_by_id(config.debug_player)
			session.auto_logged = true
		end
	end
end
