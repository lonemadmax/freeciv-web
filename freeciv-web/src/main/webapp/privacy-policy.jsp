<%@ include file="/WEB-INF/jsp/fragments/i18n.jsp"%>
<!DOCTYPE html>
<html lang="en">
<head>
	<%@include file="/WEB-INF/jsp/fragments/head.jsp"%>
</head>
	<div class="container">
		<%@include file="/WEB-INF/jsp/fragments/header.jsp"%>
		<h2>Privacy policy</h2>
		<ul>
			<li>This is a free service provided to users.</li>
			<li>This is the internet, so yeah, we know the IP that hits the server.</li>
			<li>It is a personal hobby project with no lawyers around. If you think we are doing something wrong, please say it, don't sue.</li>
			<li>It can be used without the user providing any really personal information, such as email address, real name or address.</li>
			<li>It can be used with the user providing their e-mail address. This e-mail address can be used for Play-by-email games. It is also needed to sign up and keep your games more or less public, but it doesn't have to be a real e-mail address.</li>
			<li>It allows you to enter a player name when starting a game, to personalize your game experience.</li>
			<li>That name, along with a password and some config options are also saved in your browser. If it is a public device, you user and password for the game are also public. You may remove that info and the only consequence would be that you'd have to reenter it the next time you play.</li>
			<li>We use <a href="https://trackjs.com/">Track.js</a> to detect and log Javacript errors.</li>
			<li>We use <a href="https://www.google.com/recaptcha">Google reCAPTCHA</a> in signups and password resets to prevent spam. That means Google collect some information. Per their policy for this service, that is only used to give the service and enhance it, not for their personalized ads.</li>
			<li>The servlets use a session cookie: JSESSIONID. As its name implies, it dies with the session. We are not currently using it for anything, and it may be removed some day.</li>
			<li>Some external resources may use cookies, like recaptcha. You should know how to block them if that's what you want, it's your browser. Despite what some bureaucrats may think, an education problem is not solved just with a click-through banner. They should have passed a law to make all drivers stop and sign a consent whenever they enter a track with traffic cameras.</li>
			<li>Support for the game is provided by mailing lists and online forums.</li>
			<li>If all of GDPR and similar laws apply to this site... Well... Erm... We are not keeping records of consent to save and process personal information, for example. On the other hand, you are not required to give it. Again, read the other points here. Even if you sign up for play-by-email games, we don't need a real name and you can set up a mail address just to play here. I think that only leaves the IP, and you can use a proxy for that. Oh, and what you write in the game may be saved in the savegame. You can delete them, and you should not publish personal information in random chats.</li>
		</ul>
		<%@include file="/WEB-INF/jsp/fragments/footer.jsp"%>
	</div>
</body>
</html>	
