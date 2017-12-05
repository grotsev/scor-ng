import org.junit.Test;
import org.openqa.selenium.By;

import static com.codeborne.selenide.CollectionCondition.size;
import static com.codeborne.selenide.Condition.text;
import static com.codeborne.selenide.Condition.visible;
import static com.codeborne.selenide.Selenide.*;

public class LoginTest {
  @Test
  public void login_as_admin() {
    open("http://localhost:8000/src/index.html");
    $(By.id("register-login")).val("admin").pressEnter();
    $(By.id("register-password")).val("admin123").pressEnter();
    $("div.container-fluid").shouldHave(
        text("Hello, you are at Home!"));
  }
}
