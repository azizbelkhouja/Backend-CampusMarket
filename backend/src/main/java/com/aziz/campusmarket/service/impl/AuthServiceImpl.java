package com.aziz.campusmarket.service.impl;

import com.aziz.campusmarket.config.JwtProvider;
import com.aziz.campusmarket.domain.USER_ROLE;
import com.aziz.campusmarket.modal.Cart;
import com.aziz.campusmarket.modal.Seller;
import com.aziz.campusmarket.modal.User;
import com.aziz.campusmarket.modal.VerificationCode;
import com.aziz.campusmarket.repository.CartRepository;
import com.aziz.campusmarket.repository.SellerRepository;
import com.aziz.campusmarket.repository.UserRepository;
import com.aziz.campusmarket.repository.VerificationCodeRepository;
import com.aziz.campusmarket.request.LoginRequest;
import com.aziz.campusmarket.request.SignupRequest;
import com.aziz.campusmarket.response.AuthResponse;
import com.aziz.campusmarket.service.AuthService;
import com.aziz.campusmarket.service.EmailService;
import com.aziz.campusmarket.utils.OtpUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final CartRepository cartRepository;
    private final JwtProvider jwtProvider;
    private final VerificationCodeRepository verificationCodeRepository;
    private final EmailService emailService;
    private final CustomUserServiceImpl customUserServiceImpl;
    private final SellerRepository sellerRepository;

    @Override
    public void sendOtp(String email, USER_ROLE role) throws Exception {

        String SIGNING_PREFIX = "signin_";
//        String SELLER_PREFIX = "Seller_";

        if (email.startsWith(SIGNING_PREFIX)) {
            email = email.substring(SIGNING_PREFIX.length());

            if (role.equals(USER_ROLE.ROLE_SELLER)) {

                Seller seller = sellerRepository.findByEmail(email);
                if (seller == null) {
                    throw new Exception("Seller not found");
                }
            }
            else {
                User user = userRepository.findByEmail(email);
                if (user == null) {
                    throw new Exception("No User with this Email");
                }
            }


        }

        VerificationCode isExist = verificationCodeRepository.findByEmail(email);

        if (isExist != null) {
            verificationCodeRepository.delete(isExist);
        }

        String otp = OtpUtil.generateOtp();

        VerificationCode verificationCode = new VerificationCode();
        verificationCode.setOtp(otp);
        verificationCode.setEmail(email);
        verificationCodeRepository.save(verificationCode);

        String subject = "CampusMarket Login/Signup Code";
        String text = "Your Code is " + otp;
        emailService.sendVerificationOtpEmail(email, otp, subject, text);

    }

    @Override
    public String createUser(SignupRequest req) throws Exception {

        VerificationCode verificationCode = verificationCodeRepository.findByEmail(req.getEmail());

        if (verificationCode == null || !verificationCode.getOtp().equals(req.getOtp())) {
            throw new Exception("Wrong Otp");
        }

        User user = userRepository.findByEmail(req.getEmail());

        if (user == null) {
            User  createdUser = new User();
            createdUser.setEmail(req.getEmail());
            createdUser.setFullName(req.getFullName());
            createdUser.setRole(USER_ROLE.ROLE_CUSTOMER);
            createdUser.setMobile("123456789");
            createdUser.setPassword(passwordEncoder.encode(req.getOtp()));

            user = userRepository.save(createdUser);

            Cart cart = new Cart();
            cart.setUser(user);
            cartRepository.save(cart);
        }

        List<GrantedAuthority> authorities = new ArrayList<>();
        authorities.add(new SimpleGrantedAuthority(USER_ROLE.ROLE_CUSTOMER.toString()));

        Authentication authentication = new UsernamePasswordAuthenticationToken(req.getEmail(), null, authorities);
        SecurityContextHolder.getContext().setAuthentication(authentication);
        return jwtProvider.generateToken(authentication);
    }

    @Override
    public AuthResponse signin(LoginRequest req) throws Exception {

        String username = req.getEmail();
        String otp = req.getOtp();

        Authentication authentication = authenticate(username, otp);
        SecurityContextHolder.getContext().setAuthentication(authentication);

        String token = jwtProvider.generateToken(authentication);

        AuthResponse authResponse = new AuthResponse();
        authResponse.setJwt(token);
        authResponse.setMessage("Logged in Successfully");

        Collection<? extends GrantedAuthority> authorities = authentication.getAuthorities();
        String roleName = authorities.isEmpty() ? null : authorities.iterator().next().getAuthority();

        authResponse.setRole(USER_ROLE.valueOf(roleName));

        return authResponse;
    }

    private Authentication authenticate(String username, String otp) throws Exception {

        UserDetails userDetails = customUserServiceImpl.loadUserByUsername(username);

        String SELLER_PREFIX = "Seller_";
        if (username.startsWith(SELLER_PREFIX)) {

            username = username.substring(SELLER_PREFIX.length());

        }

        if (userDetails == null) {
            throw new BadCredentialsException("Invalid Username");
        }

        VerificationCode verificationCode = verificationCodeRepository.findByEmail(username);

        if (verificationCode == null || !verificationCode.getOtp().equals(otp)) {
            throw new Exception("Wrong Verification Code");
        }

        return new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
    }
}
