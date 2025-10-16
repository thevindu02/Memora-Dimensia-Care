package Memora.DimensiaCareApplication.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class DeepLinkController {

    @GetMapping("/reset-redirect")
    public ModelAndView handlePasswordResetRedirect(@RequestParam String token) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("reset-redirect");
        modelAndView.addObject("token", token);
        modelAndView.addObject("deepLinkUrl", "memora://reset-password?token=" + token);
        return modelAndView;
    }

    @GetMapping("/guardian-connection-redirect")
    public ModelAndView handleGuardianConnectionRedirect(@RequestParam String token) {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("guardian-connection-redirect");
        modelAndView.addObject("token", token);
        modelAndView.addObject("deepLinkUrl", "memora://guardian-request?token=" + token);
        return modelAndView;
    }
}
