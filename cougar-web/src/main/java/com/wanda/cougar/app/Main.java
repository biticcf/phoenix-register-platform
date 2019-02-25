/**
 * 
 */
package com.wanda.cougar.app;

import org.springframework.boot.Banner;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.support.SpringBootServletInitializer;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;
import org.springframework.context.annotation.Configuration;

/**
 * @Author: DanielCao
 * @Date:   2017年5月1日
 * @Time:   下午5:39:52
 * SpringBoot 主方法
 * @SpringBootApplication相当于
 *     @Configuration+@EnableAutoConfiguration+@ComponentScan
 * @EnableAsync 启用异步服务
 */
@Configuration
@EnableAutoConfiguration
@EnableEurekaServer
public class Main extends SpringBootServletInitializer {
	// war启动入口
	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return configureApplication(builder);
	}
	
	// jar启动入口
	public static void main(String[] args) throws Exception {
		configureApplication(new SpringApplicationBuilder()).run(args);
	}
	
	private static SpringApplicationBuilder configureApplication(SpringApplicationBuilder builder) {
        return builder.sources(Main.class).bannerMode(Banner.Mode.CONSOLE).registerShutdownHook(true).web(true);
    }
}
