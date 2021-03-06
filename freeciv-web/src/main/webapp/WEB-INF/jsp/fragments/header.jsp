<nav class="navbar navbar-inverse navbar-fixed-top">
	<div class="container">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
		<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
			<span class="sr-only"><fmt:message key="nav-toggle-navigation"/></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		<a class="navbar-brand" href="/">
			<!--Logo font is: Liberation Sans Bold Italic -->
			<img src="/images/logo-top.png" alt="Freeciv-web">
		</a>
		</div>

		<!-- Collect the nav links, forms, and other panel-freeciv for toggling -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
		<ul class="nav navbar-nav">
			<li><a href="/webclient/?action=new&amp;type=singleplayer">New Game</a></li>
			<li class="dropdown">
				<a href="/game/list?v=singleplayer" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
					<span onclick="window.location='/game/list?v=singleplayer'">Online Games</span> <span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a href="/game/list?v=singleplayer">Single-player</a></li>
					<li><a href="/game/list?v=multiplayer">Multiplayer</a></li>
					<li><a href="/game/list?v=play-by-email">Play by Email</a></li>
					<li role="separator" class="divider"></li>
					<li><a href="/games/">History</a></li>
				</ul>
			</li>
			<li class="dropdown">
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
					<span onclick="window.location='http://forum.freeciv.org/f/viewforum.php?f=24'">Forums</span> <span class="caret"></span>
				</a>
				<ul class="dropdown-menu">
					<li><a href="http://forum.freeciv.org/f/viewforum.php?f=24">Freeciv-web <fmt:message key="nav-forum"/></a></li>
					<li><a href="https://www.reddit.com/r/freeciv">reddit.com/freeciv</a></li>
				</ul>
			</li>
			<li><a href="/contributing.jsp">Contribute</a></li>
		</ul>
		<form class="navbar-form navbar-right hidden-sm hidden-md" action="https://duckduckgo.com/" style="width: 220px;">
			<input type="hidden" name="sites" value="www.freeciv.org,forum.freeciv.org,freeciv.wikia.com">
			<div class="form-group">
				<div class="input-group">
					<input type="text" class="form-control" name="q" placeholder="Search Freeciv...">
					<span class="input-group-btn">
						<button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
					</span>
				</div>
			</div>
		</form>
		</div><!-- end navbar-collapse -->
	</div><!-- end container-fluid -->
</nav> <!-- end nav -->
<!--[if lt IE 8]>
	<p class="browserupgrade">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> to improve your experience.</p>
<![endif]-->
